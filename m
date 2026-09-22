Received: from mail-wr2-f36.google.com (mail-wr2-f36.google.com [74.125.225.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFA9343D72
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 04:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050530; cv=none; b=dfIdkmddsKi88jqme7325HmGGd2EYlF23739UwocBWTWM2Tbb3MvIg2LRRojf2G7a41Zu8RAcAGU8LSSy5ZVnT3WTq72LiPFpbkV8Hj7i3GK72kPHf75VJson7AiRj8q1RrMTR69D0bOcjbn9i/xgTWd3RiI158mPu+9/WfStOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050530; c=relaxed/simple;
	bh=BZSPWsHs8ySrvznbWYHNmsqeAhLfduOjK+NZrhaVHic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QKcklr1+LLeblvML93WXqOXEJ/EMDnB0nuZFyEOcfqmFWNP8n+vIrNvsFLNtMMHbx3FC42pB8LumQ18ZtOuCPOX+Nf89+dV3MoV8aAyrorycy2ob3Enk8E4j+jWcPlCPz+pJC5uVyzwlavCt+NNBWGmXh/6XAoNKwtQ1DifVIeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCXxKGzF; arc=none smtp.client-ip=74.125.225.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCXxKGzF"
Received: by mail-wr2-f36.google.com with SMTP id ffacd0b85a97d-4843c3ee4cfso1999806f8f.2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 21:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790050526; x=1790655326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=41Eq5jwP5e7Kp+sNbo80/V95RERvyCR/y7dxJCLxTVc=;
        b=CCXxKGzFoSEDmFzkwK8eijoOBPmB06QttrXJoxdv2eCOZvy48mjY6r1qLKPMXRFyUP
         2h7kUJMVDYpM5zsmpW8WQ4akD5up0jvcA6ZktTwqxMCtnIzKUBTv9GQnJENFfMYHnj92
         z7WYcePMLKd200nh9Mca5Klss8bg5ZHzrbohCrEI5cwyMzopnvCWiQSGut8HedJsAquV
         ywDuMWkCYQQvgMSGmpl/EYogGMVmialJMXRuJDbDt/PwlD/jGGHs0h9Oj586ElL6EzbX
         XCqqTI0oG1WRRssAvNfI3WWPcGr3NNW75KCIabhwk0H2E5i6XmS0uZuMcs06H7RAd7W4
         DQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790050526; x=1790655326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=41Eq5jwP5e7Kp+sNbo80/V95RERvyCR/y7dxJCLxTVc=;
        b=mCB9Ibov2jwyp5j72jQ4P/8T6K8tDAgoRYRBOEmdXmLG9rxOsA5aJ5yC0Y/CqCxPVs
         AaaSor3J0I6WYP8eftWmlbOtY9BR5WrAF6mXjg1aYLklt0B3VMgBDO3hI1l/Vbr51hri
         KrvUm043PoGFqMVZPsEokR7dS6rQ6AX+Ku5PuuRisdKkLYeB2WhcitVOw3jFc8ZYBF0/
         Ve5O4tJAWfh+3g5oxpBC2BI5PGU7u2IktHEGOXibe8eEs8GKx16UTWqEkWr6Z9kDJrCZ
         JgaBXI3t4MPQTKlo9SP+kjbcfIjJjANgkbtvTDtkAo6DkfnjipfqFL16EjCp2aLAws10
         99hg==
X-Gm-Message-State: AFuF++klHTw5AFjNDTUfoRk5jbVe8VQE3PI79FO/YJv8sm9Ar1Uf3AdL
	iRH85TfhMI7yiSG2IIMk/ytV61YXAmA6XYzSvE47JNKLiqwYKCgF6DGQ
X-Gm-Gg: AYBFou0d6Rr1zsWs2X/SE8bZzKlMbBiRloZdm5ntNYSuIuGwAmXoxYw/B1tljzvh9HD
	LuxW0WEmY8xmvL0k4G95Mq+SAZKhj8qpaW5RKCni3u9HMKxt6e9BSM9DLwi8Ikq3r4sxZgD+iZf
	E1asl+eeJBLv2OWXa2Gm80pW2NXEN1wQdVqkPVddKhAhq8l5byH3b8vGrBLmD3zJOc043IqN2mk
	rkaaqvos8Nr9ZbGWNPDidDubHnESCkYBZMpFjBwkWKsxkTMQ3X+4umOSSt2AArNuzHrhRCAqU2A
	Dmeu+BrmWLHLaCrmiPsQ4vIe5vWzibeCApne0Z3ckQ3FZDJ1N0xqj2H9yUlMtxcfvHmxRoAiVJs
	vGNmKc0x5WbCodXI8NfULUN6zfodsPxtvnkpevXbV9SbrrOOCdzqIEr0WaDGnVxyMx3qfhA1CNI
	4KRlvxxOWIKDCyWcazB1TuknT8AVjRt+OiBQme+dv1aFnrMMo2o/CeChawJJ0W4Hpocw9BndFrG
	OehkWywGqtrfzXnQ2TxWeLOXRQaNEpiEqaDXfNpB0ZjZ/HFhLILrFzhVkvM9pJPwYJYSo8cugLA
	QCg3hyc8FO/1q+4rcS3z0F2Zft0PfaLUQ3ze59d20fzZ92tORfbw62/gQXqUFMxXr9TDpzgMW2L
	F8G1S4A==
X-Received: by 2002:a05:6000:2201:b0:487:725:8204 with SMTP id ffacd0b85a97d-4871e36bf42mr18440615f8f.44.1790050526412;
        Mon, 21 Sep 2026 21:15:26 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a5e6-3401-ecdc-1e24-2e52-02d6.310.pool.telefonica.de. [2a02:3100:a5e6:3401:ecdc:1e24:2e52:2d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862795215sm1616996f8f.37.2026.09.21.21.15.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 21:15:25 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org
Subject: Re: [PATCH 09/20] crypto: x86/aes-cbc - Remove superseded CBC skciphers
Date: Tue, 22 Sep 2026 06:15:19 +0200
Message-Id: <20260922041519.14996-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260921050910.296144-10-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org> <20260921050910.296144-10-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 20 Sep 2026 22:08:55 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> Now that the AES-CBC (and AES-CBC-CTS) library functions are optimized
> with dedicated AES-NI code and exposed via the skcipher API via
> crypto/aes.c, the similar implementation in aesni-intel is redundant.
> Remove it.

Hello Eric,

This breaks the 32-bit build from here until patch 13.

After this patch the only callers of aesni_skcipher_setkey() are the
CTR and XTS skciphers, and those are under #ifdef CONFIG_X86_64. On
i386 the function is left unused, and WERROR is on in i386_defconfig
and allmodconfig:

  arch/x86/crypto/aesni-intel_glue.c:104:12: error: 'aesni_skcipher_setkey' defined but not used [-Werror=unused-function]

Patch 11 does the same to xts_setkey_aesni(). Patch 13 removes both
helpers, from there on it builds again. I built every commit of the
series with i386_defconfig plus CRYPTO_AES_NI_INTEL=y, gcc 15.2:

  08 ok
  09 aesni_skcipher_setkey unused
  10 aesni_skcipher_setkey unused
  11 aesni_skcipher_setkey, xts_setkey_aesni unused
  12 xts_setkey_aesni unused
  13 ok
  14 ok

x86_64 and riscv64 build at every commit, so this is the only break I
found.

lib/crypto/x86/aes-aesni.S is built for 32-bit too, so after patch 7
the 32-bit aesni-intel module is already redundant. Moving the
"depends on 64BIT" from patch 14 ahead of patch 8 would avoid the
problem, the glue file is then never built for 32-bit while the
skciphers go away. Patch 14 as a whole does not move cleanly, its help
text and Makefile hunks are written against the tree after patch 13.

Thanks,
Karl
