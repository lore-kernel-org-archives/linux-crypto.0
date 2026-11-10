Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794274810;
	b=K+ZowGSK9/Hvgh04tFfKzXFVCN1b1Lfv+eSsbuIRk8LYZELTojeDzvJ1X7Y1CG+XlspE
	 +vkTatxWqAC/Ddtvbt/FtlTb+tGOP81x67YO5cGqQxL3OMtPKrJ8iT9vzSZ2oiQ32opEj
	 9kKGWRD+5OuLWmwHEQyBxTO6ALHsR9iY3mAyugC6Q9ji/DCoe/CewvOYexGcipk5q+AjP
	 oSe6DfhjPj+dfaBKNRZl/oh/m7x7p0YztNdauJIaIBPyxi0izle6zS1Dmu3gBERCP556J
	 CKtIhq7nFKhUPyphSl3943inwpQ+f4q8tTrreR/R1Tw23HjUQ3XFM22RRYLzF6E9K9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794274810;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=AK/SgB0NJhyyMo/+uhJJDQ0snfVmLXzbzA7HTWtNTBs=;
	b=B0K89GrFWo6kCoraBYMNbUpYNa5HfuQpDJoITZXJtizT+BXdxs9HD7YNmciC1zy9DTg1
	 X0NqFSDRbm19FXSprbA2Zu+aEeM2nvvcm91xJKoPb7IFA2TfXm7jt0o3PnRfWCbL+CYHY
	 4yZ2qN4h01sCIPMcEk4HIPZerQYrJX2SUD8FHVFihm+DzcGHbEV6v0GxIpvadprZekSqv
	 GgCeb4q3muvC136ZJu/+rPhIQGNn4wEQH770NQO87HJtHu6T19kycRHuxb6PXArBzs0m9
	 MzvehsX7+kBwg+UIZ1/ihshsaqHrQ3OqaNKSP7vz2bVQOqCUyq9vW4RJe2rTaeOmhkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="z/pehWdh";
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30718606A325;
	Tue, 10 Nov 2026 01:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30718606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=z/pehWdh
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AK/SgB0NJhyyMo/+uhJJDQ0snfVmLXzbzA7HTWtNTBs=;
	b=z/pehWdhVRd/ELfMH/gt5hqXy00rS0mSKpMJfKKpoUb95Kz3+hvKZOcvSGcXpUCFCOFyeTo6I
	O44kGYOmFW4yb8HA+sfsJmWg8arK1dkAdareBWdQ3WJGeKw2j35GImzfqDptOFrUXROU/JdNmN3
	XSi3f3715y4lEoE7y1XpwCk=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jNq8P4HRgzLlvw;
	Tue, 10 Nov 2026 09:39:49 +0800 (CST)
Received: from whupemk300004.china.huawei.com (unknown [7.152.185.168])
	by mail.maildlp.com (Postfix) with ESMTPS id EFD2940586;
	Tue, 10 Nov 2026 09:40:03 +0800 (CST)
Received: from huawei.com (10.67.174.33) by whupemk300004.china.huawei.com
 (7.152.185.168) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 10 Nov
 2026 09:40:02 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, Ignat
 Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, <lujialin4@huawei.com>
Subject: [PATCH] crypto: asymmetric_keys: verify_pefile: fix integer underflow in pefile_strip_sig_wrapper
Date: Tue, 10 Nov 2026 09:56:57 +0800
Message-ID: <20261110015657.528337-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk300004.china.huawei.com (7.152.185.168)

The pefile_strip_sig_wrapper() function validates the win_certificate
wrapper that precedes the PKCS#7 signature in a PE binary.  It checks
that the wrapper length does not exceed the certificate table size
(``wrapper.length > ctx->sig_len``) but fails to verify that the
wrapper length is at least ``sizeof(struct win_certificate)`` (8 bytes).

When a crafted PE image supplies a wrapper with ``length`` in the range
[1, 7], the subsequent arithmetic::

    ctx->sig_len = wrapper.length;      /* e.g. 1 */
    ctx->sig_offset += sizeof(wrapper);
    ctx->sig_len -= sizeof(wrapper);    /* 1 - 8 = 0xFFFFFFF9 (unsigned) */

underflows the unsigned ``ctx->sig_len`` to a value near UINT_MAX.  The
following ``sig_len < 4`` sanity check is bypassed because 0xFFFFFFF9 is
greater than 4.

The underflowed ``sig_len`` is then passed to verify_pkcs7_signature()
and onwards to asn1_ber_decoder().  The ASN.1 decoder's own
``datalen > 65535`` entry guard can be satisfied by constructing a
PKCS#7 length field of exactly 65535 (e.g. ``30 82 ff fb``), allowing
the decoder to proceed and attempt to read OID octets beyond the
allocated vmalloc buffer, triggering a page fault in look_up_OID()::

  BUG: unable to handle page fault for address: ffffd1e986cb2000
  #PF: supervisor read access in kernel mode
  RIP: 0010:look_up_OID+0x14/0x100
  Call Trace:
   pkcs7_note_OID+0x33/0xa0
   asn1_ber_decoder+0x363/0xbd0
   pkcs7_parse_message+0xd9/0x1b0
   verify_pkcs7_signature+0x24/0x80
   verify_pefile_signature+0x7b/0xf0
   kexec_kernel_verify_pe_sig+0x1b/0x40
   kimage_file_alloc_init+0x1d8/0x3f0
   __se_sys_kexec_file_load+0xc6/0x270

This is reachable through the kexec_file_load syscall on architectures
that verify PE signatures (x86 bzImage with
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG, arm64 Image with
CONFIG_KEXEC_IMAGE_VERIFY_SIG), requiring CAP_SYS_BOOT.

The oops occurs while the caller holds kexec_lock; if the faulting task
is killed, the lock is never released, leaving all subsequent kexec and
kdump operations permanently returning -EBUSY until reboot.

Add a lower-bound check on wrapper.length before the subtraction to
prevent the underflow.

Fixes: 09dacbbda935 ("pefile: Strip the wrapper off of the cert data block")
Cc: stable@vger.kernel.org
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
---
 crypto/asymmetric_keys/verify_pefile.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index cec99db14129..cfa85ccb1cf7 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -146,6 +146,11 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 			ctx->sig_len, wrapper.length);
 		return -ELIBBAD;
 	}
+	if (wrapper.length < sizeof(wrapper)) {
+		pr_warn("Signature wrapper too small (%x < %zx)\n",
+			wrapper.length, sizeof(wrapper));
+		return -ELIBBAD;
+	}
 	if (wrapper.revision != WIN_CERT_REVISION_2_0) {
 		pr_warn("Signature is not revision 2.0\n");
 		return -ENOTSUPP;
-- 
2.43.0

