Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2262528394;
	Tue, 21 Nov 2023 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POVK2c2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9422EC433C8;
	Tue, 21 Nov 2023 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700592767;
	bh=5RbPe9Jo0Kx3jw4qthF98qjBS4eZ7mQNCwFgjLRcjnI=;
	h=Date:From:To:Cc:Subject:From;
	b=POVK2c2wUB2WPyUQZ1NtanCPyJem4EWudfnE4UYZaZ0vaiCOrIS/HI8x2cXwXfwVb
	 0MXJ8q+hnv02iCqaJQ2ZZkkJRfA4Q6dYuo6hON2+9iCHeYTYixTHVI5eWbDKuVF/JW
	 41F0ZeT4rNZer1RONY+r6xxSrHp1QSPCU9ntqIptnX2hY4dAojK6ucWB1HMMb+qMpr
	 rePbvv2uzJiY6cxlhubAa5tyRExehUcMwP/773+vC4QUvT4pB1iW5eGE6XPv2g7klm
	 fvzObIfzE3FmkuqyX8hCfHdZmLwKsi36JJVYy8lez7sGa1w+cvvyRV+MMt+YNDgjqM
	 xOSzs7obbDfUQ==
Date: Tue, 21 Nov 2023 12:52:44 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] powerpc/crypto: Avoid -Wstringop-overflow warnings
Message-ID: <ZVz8fLtrYTz+YSjn@work>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The compiler doesn't know that `32` is an offset into the Hash table:

 56 struct Hash_ctx {
 57         u8 H[16];       /* subkey */
 58         u8 Htable[256]; /* Xi, Hash table(offset 32) */
 59 };

So, it legitimately complains about a potential out-of-bounds issue
if `256 bytes` are accessed in `htable` (this implies going
`32 bytes` beyond the boundaries of `Htable`):

arch/powerpc/crypto/aes-gcm-p10-glue.c: In function 'gcmp10_init':
arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: error: 'gcm_init_htable' accessing 256 bytes in a region of size 224 [-Werror=stringop-overflow=]
  120 |         gcm_init_htable(hash->Htable+32, hash->H);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: note: referencing argument 1 of type 'unsigned char[256]'
arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: note: referencing argument 2 of type 'unsigned char[16]'
arch/powerpc/crypto/aes-gcm-p10-glue.c:40:17: note: in a call to function 'gcm_init_htable'
   40 | asmlinkage void gcm_init_htable(unsigned char htable[256], unsigned char Xi[16]);
      |                 ^~~~~~~~~~~~~~~

Address this by avoiding specifying the size of `htable` in the function
prototype; and just for consistency, do the same for parameter `Xi`.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20231121131903.68a37932@canb.auug.org.au/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index 4b6e899895e7..f62ee54076c0 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -37,7 +37,7 @@ asmlinkage void aes_p10_gcm_encrypt(u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
 asmlinkage void aes_p10_gcm_decrypt(u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
-asmlinkage void gcm_init_htable(unsigned char htable[256], unsigned char Xi[16]);
+asmlinkage void gcm_init_htable(unsigned char htable[], unsigned char Xi[]);
 asmlinkage void gcm_ghash_p10(unsigned char *Xi, unsigned char *Htable,
 		unsigned char *aad, unsigned int alen);
 
-- 
2.34.1

