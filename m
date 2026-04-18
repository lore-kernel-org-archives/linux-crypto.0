Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0881B78F3
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776535006; cv=pass; b=N5bWALjQM0b2ADS6wiShlQxMhNFanJx+I1QFZXn3VVimW/71N9oS/WZmPXpHixKVi1tVScIUM33gfSmzPa4lQjiXlmXsjXMsIydu6FVwGljqFFU36xRk4wR1lZhIuAkDoQ74+TOCle/t3dLbJDKZQx49Kv2LdcJ5B79MpZTof/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776535006; c=relaxed/simple;
	bh=2gYCKfN/e4XX88DqEAREwJyHD3XEyYy67FJpt4Q1jeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VxWUs7MhGZ6o+uLWWDeGPy2FpwJ9DYSWgfnzAnBQBoHgtJinlXJkqP3Z3osvccVCW9MkTegIav9dLSJ7UFJ7UQFVwAK53thwQoT0zfNlKEMlyLpON/2cU3pj+SJdHpmtpokKu9YCv8HS6L0+YYbh7+naHv8ISz3oWO+/0zEPcTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWZ6cuPW; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWZ6cuPW"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-65006c99d38so1761410d50.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 10:56:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776535004; cv=none;
        d=google.com; s=arc-20240605;
        b=Hr8PtiZHfSEN0ZU5Y/FZZXmm2E7JZ/PPm7t2kEepokYh8nS/6evo28vy1svNC36QZ/
         X+NxdxWHt0t37crodGdeHmniPFM94zw1I37yKfCBPcNne1C141B+OXJkNXovB0mR20C6
         eOLCynM8kzAKGdIPXp1MYTViu6s7Bc2cRqRcXf9u6Vhljm9nUGBcKtnw9Krr6K5lFbEr
         GLLNM13TYf337gBYs9WQKiUPYC5o4lJtZiXmsfrc0Clu/rwQWJAN8L4JWz2D7zsKfCHw
         r8qKc7AeTV26xoWlIJI3km0uk6lIovfPpFaFZelaOb0M/stLLUYIfoOEIz0zgtqtiwFA
         IzUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zWe1FcSJQcmVIDnQpqvND6nwI9rOq1fLeSKpef3W+nc=;
        fh=j9tdaPbxaJfLjmuaw4PxRUJ/W2c5/CIKVpg2FEANDN8=;
        b=BWVzn2IcAGc2UDBRI/CYPcephfe6qI5CtQGCXXFpvJQM5alEefE1AKmTV9uhszAY/y
         Q7baTTr2zjX7MbWjQfVARkSSF/BrciwbYD3urSJ7rlLOeguX3WxB9AmdYOhsk0dJwswc
         32ugsL3Ns3w6QD9BY5jC2GSrrwB5hxVeAPiH9o54agXXLchF6U4hOVVyQh0ZjRUQxu8R
         eNx6q9auGtvb/IKcz7kuW80G0z0awmUejb3++NCR01SQuCtMbSDA9Vu4g4QnfRWS1hgp
         4yvZOycp3YDvBz4WZiHSNox2TblOb12cVZCCfd1Jo8let8Iujo7YXBrJPcVv+/nrWSNh
         0+0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776535004; x=1777139804; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWe1FcSJQcmVIDnQpqvND6nwI9rOq1fLeSKpef3W+nc=;
        b=KWZ6cuPWHVIW8hAH+Hzp69jhRGfDY2NW9Teg4Q+TXOcg2MYRED0nfrSNcNY3XfVAz8
         EnixI0zsNO7J47tGWaLAqC5WsT11Egr8u1KAOSt4MxrXc3CVWM9WFS9mTIJVMNq97Pkn
         CdCNuSbouWyRPwtv+8DRSNFRfmO5qcPA995XdyVDue5XT+wXsMDujNhNzgHQ/XeajIWt
         giVQjZPQ/6QPJDdwuQGJrLlH0mNqlN1c9aezCwTd0Vph98YzVJJhT/KQZX/OgA9juRO8
         W7Ma0LOoSg6PR19DPnwGIk8us6/JvpewWrOt33UU6erKCYmUAh9k+SNrRTT/LVpArqY3
         VFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776535004; x=1777139804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zWe1FcSJQcmVIDnQpqvND6nwI9rOq1fLeSKpef3W+nc=;
        b=DJeJLydA0cd1utJ6BWjehAktIKn4okAOMiTY+F3rVWwPl/kqcpNBxzkCQlcJPg3wS9
         VyTELFkVLh5+H26IlvM7dw15Ah5+MV6NN5xpiHvZ/CQ5Sw4piXninhKsDKJTCUA7OeDg
         W7K0pMvhZVGlcqhiTH7LSLKcRJnkey2Q1dAVB8E5M0+VVHZKmAlc+oDF7cUty/3a2vbJ
         49UXohdsEwEbM05fr8Ilujl6UeGhKjdDhrYDJqZZIJ+0zjxO6iCdT8ZKO1TWQ2/wpRkZ
         uz97F9zwo17/EwSMIxKWCeLd0kSrmxl9XBSI4/1MkviFM4+HTpZSiI8D6cv3NyXkJaZz
         DpJw==
X-Forwarded-Encrypted: i=1; AFNElJ91Xv9Vww1HhPk/M6I2PoLn27YidH6PrAx2lQFaeWX368rBzrfxK6K0HYh73e+xMAfOyNaSUa2Wqlu1iUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTjQK0cHJSA2fKCI2VXgNK75ovmc+mXRJWXrvdHETHfz8mnvvC
	cbkdREWMIQNjNAiLOuCCZx5XaooKrU1IGZSMuydlN3p4bDT+iVyoZwSteYAWFmgaxYKB4f9bTne
	s300l2lkCDdJ6zyCLJE7LxJC8tKqhI7g=
X-Gm-Gg: AeBDievhe6kHP0UnGB4rn2uFKwDpvcTkAm1WsEbu2DqLXtmaysn1z1g0AMZefI05qX6
	+udOufpbyDarkCyZRsz40E4yGvJeMgciyQG+q4RGmbgnKd5JeRd/obnybTe0lExpJMXBl0jNCF9
	GP1lwYDBOYoI+e1HYeJNQwSdHFBkOaJb81zMVfKfKdkY33MxrpDdXLHTcw38M2add421LIfggEF
	kI+UHqWuXSes7R0TjnxgPuF+OR3v4CXsTTLAunD0Ayj6a0btcz+QdFQK4Km3dxwcN+e1y+OnU2l
	zj+jdg4kypkesR16+BPOUTrjRdLlMYoJe3N0ewpSB6mw9rQ=
X-Received: by 2002:a05:690e:430b:b0:651:bc3c:a91a with SMTP id
 956f58d0204a3-653107ef604mr5520585d50.6.1776535004544; Sat, 18 Apr 2026
 10:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260418150613.3522589-1-michael.bommarito@gmail.com> <20260418131110-mutt-send-email-mst@kernel.org>
 <CAJJ9bXzgpAR3Gm+mZu=mZJyUrc6bpd+_crOGa7HLxteKxw1DzA@mail.gmail.com> <20260418133030-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260418133030-mutt-send-email-mst@kernel.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Sat, 18 Apr 2026 13:56:33 -0400
X-Gm-Features: AQROBzAV5ttOMOY0D-fVTLEFE4Sdx8UKW8dKkYhppNEnNaJe651V_S4o9gva_Nc
Message-ID: <CAJJ9bXzgXZ43DLOfo2EANuFPx+DTyT2riCN_MQyM3jM9kXAg1w@mail.gmail.com>
Subject: Re: [PATCH v2] hwrng: virtio: clamp device-reported used.len at copy_data()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Jason Wang <jasowang@redhat.com>, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 1:39=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> Maybe we do I'm just not sure I understand how do
> all these checks help, and for what threat.
> It could be just me being dense.

I also don't feel confident about how much the differences matter.
For background, I think I lifted the pattern from similar issues in
kvm and io_uring.  Your point about request_entropy is right either
way.

Maybe we'll see if anyone else weighs in over the next few days and if
not, I'll go with your shorter fix for v3.
