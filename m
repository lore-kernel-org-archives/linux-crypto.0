Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617942E5B19
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 06:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771222511; cv=pass; b=t3Euj2R9iEqg+XtwzOQykM3jHGWBlrFCqZLDDS8+SKIOOz84cfrsYujf/a2dvKSG5oKlSMfLVffzFbgd9Im64ydLymeHHtsbewJF51xDNPWCJhNEHxpPEEyuoT5jL13l3LO5LdSy82ByAY3Gm0BN0EXBcJlz0kgwMe7sRXRLEgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771222511; c=relaxed/simple;
	bh=HaSzBXUNN04aYNe53ChzspTUmhSMQPEgxnlRMM8HFwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q84IPVY4MkC6zntaBFRpxomLdatnIHBML6gF32A7Q9TNKwyeNlv+pnBjiTjHIoxgQj9ZwU+h8pmBLXAQsMw8nkLbwnQgPRejRo+WG9meX71ltmZwBf2HDVPFhbblbMqZfzjfWsyU1hULx5EPhotZc0W4LmQyJevROQX4UqkSM14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPbAfU9f; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPbAfU9f"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ad4839e3cso272807d50.0
        for <linux-crypto@vger.kernel.org>; Sun, 15 Feb 2026 22:15:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771222509; cv=none;
        d=google.com; s=arc-20240605;
        b=JmRvBeRnwTEvHSjavkmJteTpVKQ4xmExk+28DFy1Pctsea4Kew2yK2zojq+jvthsTG
         5eMmo2/F6Q6dznwwkDO4oXqJn1lSjq8OaxSOKUeul8jmlD7nglKajfOZuWK4cuUb7acQ
         lBu2f0qrkA9nnx6m2EjtNJJQco4T+4ch0+4KV3lZZdoIg8ihETmoXyH9odp+hvlOc8An
         bRUymqePnEq3iNyPYB5KhgEZ+zEid+zPNYgk+wbWVoiQEmp1fu928toBdHRpdUUSATK3
         V265r5RE4BT+7RqTwODmP0gJJd/SnaHigAr2bPKJq0clhGr6IEJsd0mosnvoTGw4uJW8
         YbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7OLaxPGmMOUlM+H5QGZLEwi3fIBF1FV98gq1aRG1ib4=;
        fh=mVCHqnunSOmjlsMF1G9wWh6wqSTSgss6EgxDYbWGXFI=;
        b=kY7NGaBMitccKuI40B7cs2ARIXSf8qgwq1bJAjEL6WdlDv8zxjt/NwSnTkm49ARlrI
         MuEPX/bwSAAlP+QlokEQgNb6nlXUxnGSPETa98CtPQsakKqOvZVnY3o+WD+GqUGO+ivp
         JDNgX6tt9f1Qmso0f8oYK0VUYIZRn4mz9e4QfNYlPhXWXMxtTB6hDexa3UvDqcCtu31b
         f8aI49cKcg64SdFmeRLz8/QBdmD1mO5R1O5JUD7K90SxsFKmwqQV3+xokHHnSSFiTNss
         udn9it6pvOwddaBo7gfX9kZTcWntM+qhs1HMSg3UaO04Wh6bh9vwMLmQknmZbfFf1n7p
         DPhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771222509; x=1771827309; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OLaxPGmMOUlM+H5QGZLEwi3fIBF1FV98gq1aRG1ib4=;
        b=jPbAfU9fpOvTdNAOFKKMwY8S93s5YCtH+Ea7FyM5/d3WpyAg5b7pAQQ6i3xu+Woo2C
         tndQrbO2jbts6slbUm1/pwb+recmUQXIV31abg2yztPyQnhuBAl3toY8KGf2eOKcyaO+
         54UFzqNU3HuMa7KELjTrl4Lh4Th7HzikqK4km+BNzq6zdXsLnZZ4+LhaN0J+cgPMm4A7
         jLTK7WGufzDQEFdE+DK8qj6Ci0w7vIKjeex51FXEBrC9SjVyEZnfiO9R0O3sWvSX3jJb
         h/sGdyxChBCO8hO78FZONwz6F4iU574OXUka8zM4+kYrhkXY0LpINIRQdtZ9ZlumbILe
         ldqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771222509; x=1771827309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7OLaxPGmMOUlM+H5QGZLEwi3fIBF1FV98gq1aRG1ib4=;
        b=NIlDJ4plS+zw9XnOs3gOXuMKjHxAttCIPVrlpBi4v+pS80th6bRTcEiI7LNjpBVoDP
         KJegAAj2ZyFbl6t9EHXRbskN1O46lSqJiXp2r1XZ4E/r33ijMXYvVQauR2Ro/lMzS6Qs
         aez5YNY6VgRGGlSO20LvWNtKJRqm8NTxN6n6Kx0oFx/zs3eQNcMIdBEAhTzCTh+IwQaR
         pmvYRm/eYX7Kp1MCdZifisSVH8P/Ukncjr9Jo7RWTeAjs1ZInXVjhwwAe/6jaVEGHUNh
         Hw9ufguz3HbWg900cWfUivLFKJjmMiAb1vVuEZzX3McQBym1542nJPLIvf/fs3jnAQQb
         YZDw==
X-Forwarded-Encrypted: i=1; AJvYcCXNVRRGp9aq18SCO5DRKwFjWxf2WZjKCQQiDCdrMT5R3nCFCvALN4QIDzrofZepWT5d0NZu9ixMklC3Rvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ+DGQ9wSVuN/nJjQg6MMo7q02i0h4SfQLVjo8gq9yqb9CZacG
	HUlUSrArAOxGcJp6QZ7/XxD+od1GsCSgiWJ3V0C8HHfdKdsYe/hB6EE3TAzuK2vnFUGD5OnrRXA
	PXSURs4S5JEfpNagm0BoU6vmrrNMe164=
X-Gm-Gg: AZuq6aIGbX4IjhY24tn7enfAbec6lFEr/JidCIqGwAbThbBomkg4OjJgt+tWcKCryEg
	kppQ/+/fK2gyWPPUWy4MJvuZllF3xcmSXd2MyjtW5iUfLkznB9cxBT9GVcmNwh5iGYsyjHb91R6
	LMRhUeocgD3wfqmtvZAwjWb/ZP05b6lqCPqjW3V43yIq/R5GK5PIB6mcrq3Ygsfyein+v2QcIQi
	zSJJ0JoZ1VKLJ0Uq1mwgQiXnLKC9t/oCRoYqqJ7smt2gF+k7LZ8i0vwW6/f2WtpgAOdBlZq5PP5
	kwUp
X-Received: by 2002:a05:690e:688:b0:649:af59:a1c4 with SMTP id
 956f58d0204a3-64c14b2f43cmr5633576d50.2.1771222509351; Sun, 15 Feb 2026
 22:15:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260215124125.465162-2-thorsten.blum@linux.dev>
 <CAFXKEHbCrp57ruvCF2TXXcnoJF93Z5bdUd7Nt5WtM9_abtc66w@mail.gmail.com> <2E9C85C9-AD05-4BB3-A945-5ADECCB5C7E4@linux.dev>
In-Reply-To: <2E9C85C9-AD05-4BB3-A945-5ADECCB5C7E4@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Mon, 16 Feb 2026 07:14:33 +0100
X-Gm-Features: AZwV_QhV-rE-2L6EhZdu8wVKACqD128xWZDEOzyJLFfwFvFndTo9tJvFuP2QOSc
Message-ID: <CAFXKEHb+D__WYugjdbqUSSnubfsOeibfH-Q33eJGjG3kvfndwg@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix OTP sysfs read and error handling
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten,

On Sun, Feb 15, 2026 at 10:48=E2=80=AFPM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> On 15. Feb 2026, at 22:09, Lothar Rubusch wrote:
> > I tried to verify your patch on hardware today, unfortunately it did
> > not work for me.
> >
> > My setup works with current atsha204a module in the below described way=
. When
> > trying to dump the OTP zone on exactly the same hardware with a patched=
 module,
> > it only prints '0' and nothing more, see below.
> >
> > [...]
>
> Hi Lothar,
>
> thank you for your feedback. I made a small mistake in the return value
> where I forgot to add the previous length 'len'. Sorry about that!
>
> Unfortunately, I don't have the hardware right now to test this - could
> you try if it works with the following change?
>
> Thanks,
> Thorsten
>
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204=
a.c
> index 793c8d739a0a..431672517dba 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -134,7 +134,7 @@ static ssize_t otp_show(struct device *dev,
>
>         for (i =3D 0; i < OTP_ZONE_SIZE; i++)
>                 len +=3D sysfs_emit_at(buf, len, "%02X", otp[i]);
> -       return sysfs_emit_at(buf, len, "\n");
> +       return len + sysfs_emit_at(buf, len, "\n");
> }
> static DEVICE_ATTR_RO(otp);
>

This would work. I'd squash this fixup together with the proposed
patch and resubmit
a fixed version.

8<-------------------------------------------------------------->8
root@dut02:~/atsha204a-modif# insmod atmel-i2c.ko
root@dut02:~/atsha204a-modif# insmod atmel-sha204a.ko
root@dut02:~/atsha204a-modif# cat /sys/bus/i2c/devices/1-0064/atsha204a/otp
0001ED86032D0002154C033750FFFFFF20B0F703DB0CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF=
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
8<-------------------------------------------------------------->8

Best,
L
