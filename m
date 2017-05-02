From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Tue, 2 May 2017 16:01:36 +0200
Message-ID: <678884b8-89d0-92a9-f5b4-2962f963f07b@redhat.com>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au,
        Benjamin Coddington <bcodding@redhat.com>, jstancek@redhat.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdEBOBo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 May 2017 10:01:44 -0400
In-Reply-To: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/30/2017 01:04 AM, Jan Stancek wrote:
> Hi,
> 
> I'm seeing rare crashes during NFS cthon with krb5 auth. After
> some digging I arrived at potential problem with sha1-avx2.
> 
> Problem appears to be that sha1_transform_avx2() reads beyond
> number of blocks you pass, if it is an odd number. It appears
> to try read one block more.

It's not just odd vs even number of blocks. It appears to be
doing read ahead (in size of 2 blocks). For example,
for data starting at page offset 1 with length 3967, it still
crashes on access to subsequent page.

Patch below fixes it for me, but it feels more like workaround.

Regards,
Jan

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index fc61739150e7..736128267715 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -212,10 +212,41 @@ static bool avx2_usable(void)
 static void sha1_apply_transform_avx2(u32 *digest, const char *data,
 				unsigned int rounds)
 {
+	const char *last;
+	unsigned int rounds_avx2;
+
 	/* Select the optimal transform based on data block size */
-	if (rounds >= SHA1_AVX2_BLOCK_OPTSIZE)
-		sha1_transform_avx2(digest, data, rounds);
-	else
+	if (rounds < SHA1_AVX2_BLOCK_OPTSIZE)
+		goto avx;
+
+	/*
+	 * sha1_transform_avx2() can read ahead couple blocks, which
+	 * can cause problems if it crosses page boundary and next
+	 * page doesn't exist. It operates on even number of blocks.
+	 * Code below checks for worst case, where it can access
+	 * up to 3 consecutive blocks after data end. In that case
+	 * sha1_transform_avx2() is passed 3 blocks less and rest
+	 * of data is handled by sha1_transform_avx().
+	 *
+	 * +----------+---------+---------+---------+
+	 *   2x SHA1_BLOCK_SIZE | 2*SHA1_BLOCK_SIZE
+	 * +----------+---------+---------+---------+
+	 *    ^ data end
+	 */
+	last = data + (rounds + 3) * SHA1_BLOCK_SIZE - 1;
+	if (offset_in_page(last) >= 3 * SHA1_BLOCK_SIZE) {
+		rounds_avx2 = rounds;
+	} else {
+		rounds_avx2 = rounds - 3;
+		if (rounds_avx2 < SHA1_AVX2_BLOCK_OPTSIZE)
+			goto avx;
+	}
+
+	sha1_transform_avx2(digest, data, rounds_avx2);
+	data += SHA1_BLOCK_SIZE * rounds_avx2;
+	rounds -= rounds_avx2;
+avx:
+	if (rounds)
 		sha1_transform_avx(digest, data, rounds);
 }
