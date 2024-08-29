Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C25D51E
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 01:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894774; cv=none; b=E/iJjUBGjUoYZ3PJ2OgY0Cy50L22f2dk7Qcs2uKAddhCkIBdOtOu39tznuKX2KFvTyqop1D84dpAbhIo9P9wm6BpEdlIHK3YpezF5vj3W6QfxNe387SVMG3AbgI20CPtdXOlYUOIAvez/BCA4NEzL5dQLZSIiP9Zwzgw/av4C2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894774; c=relaxed/simple;
	bh=F6LYgtupOlXgjAGai0ZKkEXkGCwTktV7Rh1Kho42+dQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQeX1L1oTkWgDPAa50WhtTwBkIO57MJfrTwYK7zus0js8pMeyv3eNKFsvz0CWOWeJEWqv0VZC3cvLL95oAzYKYQnY9VO/cNARrMn0MIC0iLiKY/wde3uiBex453wknY9gAu1LssbM9GlgTvFsfoucmADBeq5r3b3O+oCf9YkvkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKIIeVBt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKIIeVBt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724894770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCKBnd0N4ngofQtqdbmG0bsbv/saL/8NeHoK/DY/VL8=;
	b=QKIIeVBtCazogDB2IFl8pBDtBS9CbxCcC8qxFlwrcIwlQSC6rDVETOkljEebDP+mCaXqS+
	rgeKF0kxJ2pynsZA7EVsHAzj0mNDKtmAzbWtlyGQhR7SPoAmf1sj5dUiYmLtKLTfnGeiOZ
	YKZzqwk1cLtwbtnDK+u1ZDj8OP4TFxc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-XHbmLpO3PvGEMkAfBpy5aQ-1; Wed, 28 Aug 2024 21:25:58 -0400
X-MC-Unique: XHbmLpO3PvGEMkAfBpy5aQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37496a7daf2so82719f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 18:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724894756; x=1725499556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCKBnd0N4ngofQtqdbmG0bsbv/saL/8NeHoK/DY/VL8=;
        b=sgtJGSZNxR2vu1ae+6LuhmjyX+X+UaJYwgG4Vas7od7fMF70Dwq0LH5OYaQfHRL3uF
         MYclYPQEvKNC/31E4XhFpBRQO089zDjUNy6V02GoRf3D4qGiX7Drg8fcLu7axuJM5nlB
         Asf5mZf+BtnK2d7rIkR3GvDmw93SIA5lE7Bnv5EF5IXuWH+amBZjm0fs1syEF5CgmqS/
         LI5a9QmtIvuuUKBPfOf7AMPDVhgimXd7IKFMAYPBSjRu2wR1/OdlesW2/25NrY2A22SN
         6FXRsDOVNNzInRC/LGgnJULuG8hLwHqD+QB/PpKF+aRltve1EamkAWbb34frU5dMyXom
         mpWA==
X-Forwarded-Encrypted: i=1; AJvYcCVWsHot2C0nahO8OICMPBVempgWm7Vsgp3kWEekB3qx33mlVBOP+mQUAbPv4CmCBCiOn6SKIN5cJPs2f+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJAsKw/T6lFSLZ8jcd9v7xzxSvBs5MO1TtS+jKBgFPi3a1U8+5
	iBq02Y4NFca+GHcBennglAC8s8GW98y60aobnQwRuO66HqoUItwNkHgTIPK45FTd2zyFRbSHlGo
	rH49nkKSVVD9dtyAOz9RgNC/Dm+CXaV5wmZX8ua2ik/f1CFbgDRq8U2qspFGoLclaAA+jWRCP2+
	DTRXLj5L90y7+8MSrpnZ/+2Cy4hUyPMObMafVX
X-Received: by 2002:a5d:6188:0:b0:367:bb20:b3e1 with SMTP id ffacd0b85a97d-3749b585e8cmr751688f8f.51.1724894756687;
        Wed, 28 Aug 2024 18:25:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+KwBJlKEFrvCMNKO3gDjDCmOoXBeyyJ7X1fRtCCoZgJdTwG2aRjnzlCpU5Q++v6rK8ksdBopA+iVJG8goB+4=
X-Received: by 2002:a5d:6188:0:b0:367:bb20:b3e1 with SMTP id
 ffacd0b85a97d-3749b585e8cmr751675f8f.51.1724894756248; Wed, 28 Aug 2024
 18:25:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828184019.GA21181@eaf> <a8914563-d158-4141-b022-340081062440@quicinc.com>
 <20240828201313.GA26138@eaf>
In-Reply-To: <20240828201313.GA26138@eaf>
From: Brian Masney <bmasney@redhat.com>
Date: Wed, 28 Aug 2024 21:25:44 -0400
Message-ID: <CABx5tq+ZFpTDdjV7R5HSEFyNoR5VUYDHm89JEHvKb-9TW6Oejw@mail.gmail.com>
Subject: Re: qcom-rng is broken for acpi
To: =?UTF-8?Q?Ernesto_A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>
Cc: Trilok Soni <quic_tsoni@quicinc.com>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-arm-msm@vger.kernel.org, Om Prakash Singh <quic_omprsing@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 4:13=E2=80=AFPM Ernesto A. Fern=C3=A1ndez
<ernesto.mnd.fernandez@gmail.com> wrote:
> On Wed, Aug 28, 2024 at 12:03:57PM -0700, Trilok Soni wrote:
> > On 8/28/2024 11:40 AM, Ernesto A. Fern=C3=A1ndez wrote:
> > > Hi, I have a bug to report.
> > >
> > > I'm getting a null pointer dereference inside qcom_rng_probe() when t=
his
> > > driver gets loaded. The problem comes from here:
> > >
> > >   rng->of_data =3D (struct qcom_rng_of_data *)of_device_get_match_dat=
a(&pdev->dev);
> > >
> > > because of_device_get_match_data() will just return null for acpi. It=
 seems
> > > that acpi was left behind by the changes in commit f29cd5bb64c2 ("cry=
pto:
> > > qcom-rng - Add hw_random interface support").
> >
> > Which Qualcomm platform you are testing w/ the ACPI? Most of our platfo=
rms
> > uses the devicetree.
>
> Amberwing.

We have a few Amberwing servers in the lab at Red Hat. I verified that
qcom-rng was crashing on boot with an upstream kernel, and it's now
fixed with this:

https://lore.kernel.org/linux-arm-msm/20240829012005.382715-1-bmasney@redha=
t.com/T/#t

Brian

