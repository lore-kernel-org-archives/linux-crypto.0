Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31EC2577C
	for <linux-crypto@vger.kernel.org>; Mon, 19 Feb 2024 10:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708338904; cv=none; b=edEMC14PmnOWo21mthxeHLSokrWtHQnbnAJX6kxhll67AZK3AF8JIMqn9hRgZBar3MkcojX1KR5O0gwQSulkw50v7yy0FjRQ+1neUB1xJtJWBTe6kHMOhagE7DZ+90J+AtBNcj3hgEAqT0KaBZ2BVqYaggkcD9+5JslOZ+K3VLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708338904; c=relaxed/simple;
	bh=n8tu26m3oZK1YFNyaBGqTJIbWfF/4wYBs1xQMVZxbFE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=OEZNFbnoizRqQc30cdWUzCdu2YsWOBrV4OsyPYDmH1Xx7kkS65VPLPYStPxoL9QYb8ebbR9vc5VGL1q7Y96aHDgDSOdrV6Tw4SlBIKM45nChq40u9gln7vARsQW8i/moclCM7oqBe0B79l3Nuvs+aiSQ95pmA7QBjQQ8RdkG1TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Bfc8z3RI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Bfc8z3RI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4125ea5d913so10947405e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Feb 2024 02:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1708338901; x=1708943701; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9ycbsLi0t9h8MohDsd9HPsQxAwjcag+LQ7Zzd41prA=;
        b=Bfc8z3RID2cBNkA8O+sFxhwbRU0mp80SX52j90Hx+owpxIg0eMOJDqXTuowCV7nugm
         ziRuSPT1h2YPzOHwYW3J1eVo+jWWEmfq7mCsQNk4hlFyXbdzF5bDFI71E0i8nTTFmJ8p
         iaJbG0diCxIPe01hbcB0dI4yw8CcKyaPf1BegNZ6ATIe4Ghldansgn9BMlO1oiTeWNXL
         zapFwMaBxB4vaKV9ZvqCRxZxbwlor9ViZ3uxycIYkMBYCTtPvope+kK9qe5eaTjM/Ogy
         XowbRjPg+xP3vK82d8noqvsYkS56O6T4VNLa7fl/WqDa0/GJS/Xt9eV+JDY3n4TGKJdO
         WZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708338901; x=1708943701;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m9ycbsLi0t9h8MohDsd9HPsQxAwjcag+LQ7Zzd41prA=;
        b=gkbQ7WIchDzI/ipULRiVVaAko2tRuipRIZTcV14wwd0KL5uNHpR5JgvV4BhbgQ6fnW
         zPQOZUaje/5u1v7ts/0MkCi+wJA3BS6KUTrhoCB3LPwZK7SgYQ3phKSiyMaLecwJxFJc
         7S+7ZR9MANdg8tKJ6q8JLpOLKxzJxm4IKecWNnU8j8QVIe0+zKrEJm+0IL+eRP+Cx+qj
         IZYzJrWnO7IoAz/+mwfbQ5nHDyO56apYbVomYEXYugsVGSwIJ77idOJIS7265kOkfygr
         Dc3XrvpAtSb8OBD1CDYwwioWF0yK6MQqvT8704kBk6uirH8g7J6afvHFyiwoxIfwFCFO
         wVVg==
X-Forwarded-Encrypted: i=1; AJvYcCX4y6oIgy2Cyi7fq8y5WkLvT1w8jjoeX24HNEWXwbTDQrcc5PtC+8iTmY/1uFEzNI0/BCHr+gQi8Y+jQbmrFjXHFJIdAmVTHwAHlruJ
X-Gm-Message-State: AOJu0Yw5uLDon85Zej/HRzjjoU56em42Iqv4okeZrgLaK3xXH97BU3XK
	ibVHntTHbL65T5j9yTP5xu2iC40/XTrgqnBrDdg3E2VGfw8WpYGl+lC/3sTaB98=
X-Google-Smtp-Source: AGHT+IFjPAJ4fuhpSh/fhJtskqrhKDQ+QhWZsMMC2miAFTn6NQtrqQAj36thD2JD/ura21aD9NsYcw==
X-Received: by 2002:a05:600c:1911:b0:411:f94b:379e with SMTP id j17-20020a05600c191100b00411f94b379emr9207828wmq.27.1708338901286;
        Mon, 19 Feb 2024 02:35:01 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id p11-20020a05600c1d8b00b004126a0dfd11sm677563wms.29.2024.02.19.02.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 02:35:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Feb 2024 11:35:00 +0100
Message-Id: <CZ8ZLKN072K5.1WRT68QL5IUSZ@fairphone.com>
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Bjorn Andersson" <andersson@kernel.org>
Cc: "Stephan Gerhold" <stephan@gerhold.net>, "Andy Gross"
 <agross@kernel.org>, "Konrad Dybcio" <konrad.dybcio@linaro.org>, "Thara
 Gopinath" <thara.gopinath@gmail.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Rob Herring" <robh+dt@kernel.org>, "Krzysztof Kozlowski"
 <krzysztof.kozlowski+dt@linaro.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Bhupesh Sharma" <bhupesh.sharma@linaro.org>,
 <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sm6350: Add Crypto Engine
X-Mailer: aerc 0.15.2
References: <20240105-sm6350-qce-v1-0-416e5c7319ac@fairphone.com>
 <20240105-sm6350-qce-v1-2-416e5c7319ac@fairphone.com>
 <ZZguvdJTyVgfxm4D@gerhold.net> <CZ6FYZLGWT3K.ZBHYDQ7TDN4B@fairphone.com>
 <pbjbhnj4opt57xswk7jfg2h2wjdv3onmg4ukxn22tsjjsnknxv@m5gy44kkbvvl>
In-Reply-To: <pbjbhnj4opt57xswk7jfg2h2wjdv3onmg4ukxn22tsjjsnknxv@m5gy44kkbvvl>

On Fri Feb 16, 2024 at 7:09 PM CET, Bjorn Andersson wrote:
> On Fri, Feb 16, 2024 at 11:46:49AM +0100, Luca Weiss wrote:
> > On Fri Jan 5, 2024 at 5:30 PM CET, Stephan Gerhold wrote:
> > > On Fri, Jan 05, 2024 at 05:15:44PM +0100, Luca Weiss wrote:
> > > > Add crypto engine (CE) and CE BAM related nodes and definitions for=
 this
> > > > SoC.
> > > >=20
> > > > For reference:
> > > >=20
> > > >   [    2.297419] qcrypto 1dfa000.crypto: Crypto device found, versi=
on 5.5.1
> > > >=20
> > > > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > > > ---
> > > >  arch/arm64/boot/dts/qcom/sm6350.dtsi | 31 ++++++++++++++++++++++++=
+++++++
> > > >  1 file changed, 31 insertions(+)
> > > >=20
> > > > diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot=
/dts/qcom/sm6350.dtsi
> > > > index 8fd6f4d03490..516aadbb16bb 100644
> > > > --- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
> > > > +++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
> > > > @@ -1212,6 +1212,37 @@ ufs_mem_phy_lanes: phy@1d87400 {
> > > >  			};
> > > >  		};
> > > > =20
> > > > +		cryptobam: dma-controller@1dc4000 {
> > > > +			compatible =3D "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> > > > +			reg =3D <0 0x01dc4000 0 0x24000>;
> > > > +			interrupts =3D <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> > > > +			#dma-cells =3D <1>;
> > > > +			qcom,ee =3D <0>;
> > > > +			qcom,controlled-remotely;
> > > > +			num-channels =3D <16>;
> > > > +			qcom,num-ees =3D <4>;
> > > > +			iommus =3D <&apps_smmu 0x432 0x0000>,
> > > > +				 <&apps_smmu 0x438 0x0001>,
> > > > +				 <&apps_smmu 0x43f 0x0000>,
> > > > +				 <&apps_smmu 0x426 0x0011>,
> > > > +				 <&apps_smmu 0x436 0x0011>;
> > >
> > > The last two lines look equivalent to me: 0x436 & ~0x0011 =3D 0x426.
> >=20
> > I don't understand the IOMMU SID + mask really, but I think I've seen
> > somewhere before like here that TZ can be a bit picky with the SIDs?
> >=20
> > https://lore.kernel.org/linux-arm-msm/opqdrmyj3y64nqqqmakjydn5rkspizufy=
eavm7ec7c7ufqz4wk@ey2a7bq3shfj/
> > https://lore.kernel.org/linux-arm-msm/11b5db69-49f5-4d7b-81c9-687d66a5c=
b0d@linaro.org/
> >=20
> > I don't quite want to risk having some obscure use case breaking becaus=
e
> > we cleaned up the dts ;)
> >=20
> > But if you're more sure than me that it won't break, let me know!
> >=20
> > >
> > > It's also a bit weird that the mask has one more digit than the strea=
m
> > > ID. And ordered numerically (by stream ID, first number) it would be =
a
> > > bit easier to read. :-)
> >=20
> > Sorting them is no problem, can do that for v2.
> >=20
>
> Where you able to do this? I don't see a v2 in my inbox, am I just
> searching poorly?

Only sent v2 some minutes ago, didn't have any more time on Friday.

Regards
Luca

>
> Regards,
> Bjorn
>
> > >
> > > Thanks,
> > > Stephan
> >=20

