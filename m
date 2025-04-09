Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F3225E80F;
	Wed,  9 Apr 2025 12:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744202807; cv=none; b=sCQa9OfTF4IXhegZI4N16xSE+1cdF+ZlM6H91ypT5VOmiMeKP5LXJDsjWRaDTTFLZ7XT7eOrJMplEeSpTruWBKEv0KyrVNSCvqxvbnOQoGHHtkze93hcA9xaj/KhAfdqLu8/JQUi7h9k2KMFx7lEW7cWlJcRX7dVOvBUfjFQiEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744202807; c=relaxed/simple;
	bh=MeWWBGTjlUvvFQ2dwgcDW5DN0xlT820wyIW0MjZrGlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TR0r1ovHqKLXh1wbpVzUK4I91VEQNx23Inl0dxD+FE575We8IZGS3zW2lJayrY8VMt0yPaFRMNC+V7hbSfFOP84czMxo/Y51+4vEfMdm7TSHmlRBOnICweZM6o6kX2sfpq+evwQRvuNpKxoeDLAj62KwiiIlDC/CbakzC+ehemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=KOC8Czrk; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="KOC8Czrk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1744202790; x=1744807590; i=markus.elfring@web.de;
	bh=MeWWBGTjlUvvFQ2dwgcDW5DN0xlT820wyIW0MjZrGlE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KOC8Czrkj4FVNXeoWnAAhjtN367USJpwt1kZYmG/65l3/Ew+NnabXSYJLN36/ZJB
	 SZafwzsNrP02DPMfY23b5IZ5Y3XkwESHF3ONKvGvQzC23Z/zoQfBvldxf7NaeTNXJ
	 UKgUwpcaen4U/liTzUZAi8lJP8/f5f+fPx4771cbdhF0F8UGxgnIhNVD2ikymPiVC
	 bIHL58LaMAFAQUGArD9Plkygfa2JHjkh7ohjgjhxoKiASOMBZ2goAgFa3F4FnamFl
	 U2/ymC8IQbGSb9cWRlIkLZIzm2hWqVJbm0wASgaxusPLZJ0GUYc1T6RVhT1eiov53
	 B4dXTWCNSP35fhAS4w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.27]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MW9ra-1tZFvQ36Mc-00Lc4g; Wed, 09
 Apr 2025 14:46:30 +0200
Message-ID: <e10ecbe1-d8c3-444d-92cb-647a1c54675f@web.de>
Date: Wed, 9 Apr 2025 14:46:28 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: crypto: sun8i-ce-hash - Refine exception handling in
 sun8i_ce_hash_run()
To: Andre Przywara <andre.przywara@arm.com>,
 Ovidiu Panait <ovidiu.panait.oss@gmail.com>, linux-sunxi@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Chen-Yu Tsai <wens@csie.org>, Corentin Labbe <clabbe.montjoie@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Samuel Holland <samuel@sholland.org>, LKML <linux-kernel@vger.kernel.org>,
 Julia Lawall <julia.lawall@inria.fr>
References: <3727de04-7993-4b81-80c0-adb40b847307@web.de>
 <20250409133610.59d42bec@donnerap.manchester.arm.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250409133610.59d42bec@donnerap.manchester.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fGRJhLFb/+v0O2mafP9QCc0EviHzvpX5ikoqmmYcIiWSJhKDnDY
 fjojfNZCKBcliE5Cmge9pM4cqDNVFNDHzBofT//KsNmyshdeZPDLItuLsHCvUVWc5cZ3G1L
 CaUjYAi2hu2A37x9JQTjlm9d1152fqk24dPLQFMnYSyV/f7pSncretj0sJdj5thPnr+uJue
 EWh45MonlU0WyMkJT5X8g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2PalMa3QEWk=;gLr3Yt97VScssGDAYWAG6YNzSG1
 8QkarCyeTXM9UGR3C4b8kQiGX7QN9CLLSJoZa31hEhIc/WpFat1dMp51bwZ8In4f7TEhJIk+6
 lDqousHP2E5M6YP1chKxQa2vDyLIQeS2ZvmrwUVJtsE7OHpXDbLo9/lon6GCjQs0Fs8nokXWI
 i1oYak0FYJanAx7gtDgrZfeqt4g04RqxuhS1Qb6C9aU85nbkFaKCLpxd70Wdph1xh916zkE0n
 xLMvP23xXJcoP5AKie1j4N2sXkiwSNHCCmM2bS0s6BI8l9FIhdbznWAlr7CdmAMPxtLE+9NQX
 UBH2lGVX38QXskZ8li5EmyzxLGIprh0JBxERToxZon66z6CTHxfYx1UFFkByD8UUkWzltxr5j
 ZbQSj2uvptUIOfOLEIw2FJbsQjPgbFhqYx98AsCE4P3COjKDP+i98d39JzApMTt2a9XcFKEU5
 zXMBM0TdSY/gTFPOZccfPEXOAMb5OsBAh6ICtGvLBOIlMDolk9PmuVIPAGZGjOLxlZ0+d2KZm
 jeKbsvuxkvA737dOS5IF1GoEIqKZCuxoG+L4P12bWGyKtURmLZXiLB2pevRCmcmtq4I+vsq+J
 q6RMzE4xXtYzyJoi86LJuLOgvvXPpHfaOnvV0HXsKondRNOv8VBk5QUMqywL5fkEygaNBZtK8
 S2Y4JeiCE+aa+QWjrZ+eRtmLA0Q001UNULWBH30kLclzkSeOG9nQw4b9EMMW+0wGHKXVtwdN9
 1vK5bUFLcGFHvZqut+gNv4mZAF38Fki48GwLfbeFD8pHC+GRBHI4M3ej+raH9o4HGtjq5vU3v
 eY4APlCk8OZgFOMSvW8WPO+7dX9OD9eRIJ0yyTZH/PsfKhaPI1oSMp2Ml37ETGxPtdTTaNpmk
 OJyRh+Qo973VajckcNMeU/jEuOAKvgmh+nBleGJvogSIFZt+h41BBGPFtLub55ZpB4uKDkRjL
 vCogFtoAs9PvwY+AqMVUbfNEjdUgKThgh4MQKaYk7z35a2gnrGGiyTJER8/KqoyQ7wjCvK8Ua
 zVsKQYtkjUN49WD8IO47NY7/xD7h1zPzWTb+dhSVzvHuVCYbd0sBWRtpf/B7ZQ+izDfCwMUSU
 +SfQKcGI5+FFt16oSHMPnvWFobp/QEZNouXfxn/F5kyIi/QCVddxVV5Abu1oNrD2n+VNCoR4E
 YZTjxGnGVMsa6RpGB0CvhmBPMBAuApFTYf3EhaSHskeZ7Og8sWT1JTSojzpOonDtnMOh/pump
 Iytgv/pKSQsqPsqWrpjZykzGl4w9kKJWaFqKQQOs4GgwwMtJ84h1lrbuBVoqO+8NP52rWwZRd
 sDqBd6xEOoahcmZOpFe4xIH/yZDpnAaQnI6GeUzi/n5vmp+c7vav9qLE4sb3PRf9jWcpGURmo
 J+sJr7TC6WBjAmuaf7oUJBuc8nDc+qbpawoC98NszBB1slMhhbiSDSGNGFNMc/Sa3/h7Ahz7y
 68vdnKhJgrhJcdk3B3lp1d99it1pmjb5+nCMuKIQYpsRB7D/IJ+XapwyMmcu9CGQG/Sc29whU
 4j2msyib3Ks2uSfAyBM=

>> Two if branches contained duplicate source code.
>> Thus avoid the specification of repeated error code assignments by usin=
g
>> additional labels instead.
=E2=80=A6
> Now there is one rather opaque label it goes to, so a reader doesn't see
> the error code immediately. And it really just saves one line per case
> here. =E2=80=A6
I imagine that such a code refinement can occasionally matter.

Regards,
Markus
