Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257A63BD
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 08:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="DlNK8ewe"
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98EC126
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 00:53:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1cc58219376so49401045ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Nov 2023 00:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1699347199; x=1699951999; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mp3uon/3Fyp4maghAodzXPtq76RuAivTg8nwoG+3C0c=;
        b=DlNK8ewekQtl7fW68gVX24qcDIoAJkkk372sd31JyRlwxmOuLvlJrzBsw+AjCbhM1z
         QGx/Bsm9R2L8T2MtnPPUrplwhuydXCbW/PDxSgPztvAY6Alms6QRspzzsL7tugV20n48
         ehRGFujL63Yx1kQiWHuvssEKJJyLSbbmZDMpXshnAx+3d6bKXb3xyDGxu8PCv+eHYKCE
         3kBFUxZlgJ+Lyj/vsPREkVrT5vOm73c7Tbii+hvV2KNG4Jni2AeAm4XvkytU0Bq4G0OI
         HZfbgcv3pfhlll7oz/nfYQG7hmQuOKjJG160yC38MsUghsHMSY0/SMcMBhLDZCTWlkeh
         mPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699347199; x=1699951999;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mp3uon/3Fyp4maghAodzXPtq76RuAivTg8nwoG+3C0c=;
        b=MK4zxa+0xZPlGRsnnnO2KK1EH7V4gOm4MhM5nf7AeY3dq1hdFXBqdymkqqsc7gByt6
         A5s/OFTfskbMaRI66+C5WLxitF7tin4UuCB7C/0ZiIlZVsgnE4YGipftNAXk+Oyv8oZe
         NJhD+TCLpp/3uBDff2bswlWzq5DIti+LoQkHvdFC+f+vVtEL5O7mTpWvZbWz/GbOUGHd
         FOCiDg5eq1N27d5oM9wH2aEp+DP/dLT6brFcVX9KvkqOpkXPxaRJzWW1oyn2lRG4nlSy
         STbH7vIhkP6+NQqJ2VBb2hbkzx2MWW4JileP0Zrcw0ctZM2fn6wTX4w5QDedoXBdhPWO
         xNNA==
X-Gm-Message-State: AOJu0YwUKXmkoLobwp4uMvskqJSENr/9UC0retfYKW4XwutrxmuB/syV
	YOkA0y4btiqfQjbHIRKpqjD91Q==
X-Google-Smtp-Source: AGHT+IHL7EnzEs9/TsQ0th1iANW9oVAkCWSJCyHyWJvnKsiTXsDOfMf5GeqEirhaJ/X//VBTrJhfPA==
X-Received: by 2002:a17:902:f392:b0:1cc:64bc:ecf3 with SMTP id f18-20020a170902f39200b001cc64bcecf3mr17796493ple.34.1699347199308;
        Tue, 07 Nov 2023 00:53:19 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:8d0c:a813:4d0:7247:8a5e? ([2402:7500:4ce:8d0c:a813:4d0:7247:8a5e])
        by smtp.gmail.com with ESMTPSA id g23-20020a1709029f9700b001c625d6ffccsm7136099plq.129.2023.11.07.00.53.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Nov 2023 00:53:18 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated AES-CBC/CTR/ECB/XTS
 implementations
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231102051639.GF1498@sol.localdomain>
Date: Tue, 7 Nov 2023 16:53:13 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 andy.chiu@sifive.com,
 greentime.hu@sifive.com,
 conor.dooley@microchip.com,
 guoren@kernel.org,
 bjorn@rivosinc.com,
 heiko@sntech.de,
 ardb@kernel.org,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Reply-To: 20231102051639.GF1498@sol.localdomain
Content-Transfer-Encoding: quoted-printable
Message-Id: <39126F19-8FEB-4E18-B61D-4494B59C43A1@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 2, 2023, at 13:16, Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
>> +static int ecb_encrypt(struct skcipher_request *req)
>> +{
>> +	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
>> +	const struct riscv64_aes_ctx *ctx =3D crypto_skcipher_ctx(tfm);
>> +	struct skcipher_walk walk;
>> +	unsigned int nbytes;
>> +	int err;
>> +
>> +	/* If we have error here, the `nbytes` will be zero. */
>> +	err =3D skcipher_walk_virt(&walk, req, false);
>> +	while ((nbytes =3D walk.nbytes)) {
>> +		kernel_vector_begin();
>> +		rv64i_zvkned_ecb_encrypt(walk.src.virt.addr, =
walk.dst.virt.addr,
>> +					 nbytes & =
AES_BLOCK_VALID_SIZE_MASK,
>> +					 &ctx->key);
>> +		kernel_vector_end();
>> +		err =3D skcipher_walk_done(
>> +			&walk, nbytes & AES_BLOCK_REMAINING_SIZE_MASK);
>> +	}
>> +
>> +	return err;
>> +}
>=20
> There's no fallback for !crypto_simd_usable() here.  I really like it =
this way.
> However, for it to work (for skciphers and aeads), RISC-V needs to =
allow the
> vector registers to be used in softirq context.  Is that already the =
case?

The kernel-mode-vector could be enabled in softirq, but we don't have =
nesting
vector contexts. Will we have the case that kernel needs to jump to =
softirq for
encryptions during the regular crypto function? If yes, we need to have =
fallbacks
for all algorithms.

-Jerry=
