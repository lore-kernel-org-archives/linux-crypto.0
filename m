Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794570435;
	b=wYRAAchEYb4lZarBOeBLq7sDpcD1tYwN2xRPO9U+rlilT5tGncRDLZEsLxXMDwqyaeIv
	 ayq2OlafpfVOL80KZaCdFl1QO5BO8lbSn8Jx13r+K9CnGQ/0FslWFH00G9Rs4FxHaglkF
	 m4Oue40YkhqMqi5FVRwjxyw+RLnT2MIHPbPus8rrt+DG1S2hFvwLr2AeKSmufco1OcsGi
	 LjfPT9xupUkyAIL0J6Z9mCgfaTkGfQydf6HN5zyAtOpyTvqzbLm64JxcHCDFfAXhHrzii
	 WUQ0mL+8SgcQkTBsDH4MyvPJ7mJ2nlZ4OK2tWYJm/HC3DkUkJWR4XkYPNVLhQq1aPsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794570435;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zJDLOTFE0u0isGyPzocQAPEPdP69LuLwHlkdkktHl4M=;
	b=pjdH+Fr+tbYcc2DSHmGrRG3u9e6epdXGxJmpdIKrmyWPsAwLQgr6ruhbOORI+QI7JhR2
	 DUgO66o1ZZLltvRKB1tZE/TClV5zmxo4jsePo7XWDyeGszXCwt7fITmOlokNodJyc108n
	 tG5HJn4T41a6fF7XTRbWFcaUXprXSqnSM7OBJDvYpXXAVx/pr6Je8HpxxGnvhJ/QxhjjI
	 J4CPQBbhLd4Ma63ss57NiwRh95hidOqZ8bg7fviTAExU59uH2YcAn3ELANwpdfTllypa0
	 lhvf8F+Bitwv7B0qu1QJZqsPj6ZqTK9I5ymIhR9+x0AwQbNdgkqlr9tzRzbGMglLakQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=YNQ2wdn1;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208C606A321
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0208C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=YNQ2wdn1
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 25C19429D0
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794570433;
	bh=zJDLOTFE0u0isGyPzocQAPEPdP69LuLwHlkdkktHl4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=YNQ2wdn1rcL5nMFfb7zp13BAIQO/t3DW/5SEUPvLdKyEFiek9pO/rvjUb8VfHrhqK
	 qjLCEsklb0xyMWvPeOnlI+oaD+wSYzCcjelerQ8PvtDaLLzN7P7yuZVTvjma+Zv2Bp
	 MU/divWw0nh3oJ8nr3DMLbLo9g+u+YJ1QTbl7uI4si4TQFfAheRSvcugipmI+/F7LS
	 lN7VAEs+FcnOJCiCv6ejMJpNoBcwXj9BgZGP45URIhK38s3f91CfqwYVGeBDNWAV+s
	 FDgkegFMPBfNUVz9IruBr6k1w11LKp10xsfY+QBf+8N948u7kpPUYuxTwZAPSYJoyb
	 TCHvnUwBtdQCMfTbbS0DlLM8amwlq762MdBD/tfR/TnlwiQlF0TyqjZRpMFKt+lb9e
	 qJpt4FezjcUDV2VLl9/j0QZJNadVd1/49leNI+aea3p6OOC0A+dRX9N9IuC5CIV+eY
	 r3Cr5nSAeuLfJ/t2tZWtstsCMIPkSF8fk31cpJSX+MIgHK9vb7eqOtCHA61Dw8PpFC
	 8A9bUn0IxoPjeNmkI6ijPbg7Fo2LRZLZrS6gMXrsa/gaDXmcuRHjww/V34+078bpi8
	 BZlSG4yiCIeparGRs4m82/6iJzmWTtePSdLEMwy3JedNLGEXH2SCiev+BTG97aorMe
	 LG8U1xJVnPWNdj6Pg3uifDRo=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b0ac277beaso728742a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794570431; x=1795175231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zJDLOTFE0u0isGyPzocQAPEPdP69LuLwHlkdkktHl4M=;
        b=tHhiPbL6I2Xpm/C95PvJ6A+Co1aApvhiQSMganL8a0m+9G+Z8vYVMti40M6qUI0tVS
         WZ/8upRYi3qBiaPBAgiZLzHvIV+D2bDGAIMSWsWfwvGFwxxCLCiSDHGyehXCFoML5SVF
         3dbHb6Rvhul2RXReprzlGM3dsBmuDsDwUg6btanYUC9mLsYKPE7f84dqnNMikO0g6dZb
         N0m6Mge5HiffKCv7rlqlaCxsqaQb46+IFpfRShaqas3X3vyFdhuMYP7XCo9Lu3biSIoq
         gIGri61Egj1cA3X0ZEjE+4hdlSYUHakq6zlzhhejFEay62pp3P8cIvcQEWD/2U3Fo7kt
         Zcig==
X-Forwarded-Encrypted: i=1; AL+hErEtI4w6upwjXazLjgLHdLBSV7VXwasQtvQ+ATeSQL2l3zcWsYTBtbyC2KSwemTxo2zdrPFZ7MV7LDovGbM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+HY/S3ZRajekwDhb2ohPrBnuLwfseD/n9491iN42HgwGpRLfh5
	WLbCXLmlNStLo103pO3+JpOSBL0NS3d3TqoZ4wwNKhVTzg2H7ZYZobezu0ttdQUixnE3KnoBOI2
	4YL+sokebFeuAOYMzC/WLv3Mn3KFWfPgGLhS6jpQdIWU8o0REhfJ68jEeI1q5boXGQMBMxid66y
	t6YmkWCA==
X-Gm-Gg: AYBFou2C3SwZsbUsI8zqIRW1uRwI87lreJvaY+hs4TXHMtXPLqaFLooqjH5coKOejC5
	oVLcioDeTgVSY/ZrwBt5od8MJkwk0xsHMZhXbRbQle+NT/BcTfrUBlr3YAykAznczL9HJhSAZm6
	ADNjMvx84uihSt3k77poIFtgIL5wq0cElOaYcppzx0VcxjXRG/ELR5ediemFDMttS/7Crzy49XF
	qTdmxASl+BIJrsXYJxpLgcDke2Z8pTiXMp/JXuOiqslOLFa7ZfxcMZTe5v6jhU+8ai+MejAl7ev
	tLdFf4fj5vQTFmm4cowqgGGK/IU36SUf2Ab3nyyUx4AlkQSftRGXX/iXCUzHuxm2yz1agG4U1IU
	uH/OxsPaOVNvlhjdARnibLFwqGcPMPGA5cOYaF5G7HjvB0hTISocHvVjRVrk=
X-Received: by 2002:a17:90b:4d0f:b0:3ac:96a3:77d5 with SMTP id 98e67ed59e1d1-3b1b0a3c5cbmr1777220a91.36.1794570431311;
        Fri, 13 Nov 2026 03:47:11 -0800 (PST)
X-Received: by 2002:a17:90b:4d0f:b0:3ac:96a3:77d5 with SMTP id 98e67ed59e1d1-3b1b0a3c5cbmr1777197a91.36.1794570430955;
        Fri, 13 Nov 2026 03:47:10 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec622b6sm4563767a91.11.2026.11.13.03.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:47:10 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: sahil.malhotra@oss.nxp.com
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	horia.geanta@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martin.kepplinger-novakovic@ginzinger.com,
	pankaj.gupta@nxp.com,
	stephane.debusne@cynove.com
Subject: Re: [PATCH v4 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Fri, 13 Nov 2026 22:47:03 +1100
Message-ID: <20261113114703.68219-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112074903.462744-1-sahil.malhotra@oss.nxp.com>
References: <20261112074903.462744-1-sahil.malhotra@oss.nxp.com>
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

Hi Sahil,

Thank you very much for your review.
I have submitted a revised version v5 as requested.

v5:

https://lore.kernel.org/linux-crypto/20261113113650.63038-1-changwei.zou@canonical.com/

Kind regards,
Changwei
