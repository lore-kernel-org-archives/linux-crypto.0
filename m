Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EACF79CD
	for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771781429; cv=pass; b=Zw6ZibHQ1RSVaLaeBtv/498Ca4pQBvLlftBrjpuX1JrJ+1MXyXeA8PTTivrilhpUm8cCyglp0MlgFSvMeZSGXb8bFAK+sEpMuOaBQ5xwApQ065wueg0pXsHlT70v8zAIz8AYJrg6rWrxDHuzuhsBF8IC65SCf6isn03zJ/LtO4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771781429; c=relaxed/simple;
	bh=WuQdtA91bXirdlbXnxD3/MRjhUKTcOvVKRMaaSclhvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b1dgYretxt2PX7oYf9YYLTf89MHLVHCbXju5huYy9wUpctJecbCydq0Eal7oHgqjammgO61EluveiPIT6PJt8Tj+VkFH1u3pOqpddrwfB7Zs+6Ewmq5/AxnO0j11ZjqOIotaqkM50f63D6KnYu054dCLiZyItMms7UYpWyp6pWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCjRzzx6; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCjRzzx6"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64ad9343163so501057d50.3
        for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 09:30:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771781427; cv=none;
        d=google.com; s=arc-20240605;
        b=gncKvFehEUH+/mB9qqHgh5NZLHVx4kMeffRiBBzHtWvbKXoTctO7pPAnVKObwtTA5A
         xo98o7mDDudd2PwSB7FwDRqa2J9+G1Z+SrKX/ZIJXyFCG7M2vQol4PELS28HiNlQImzv
         aJ/oLLTm0WBK5jEIb1WTIdVGTco4QvrqcwW8pcvbkxEl5yGmPFBGHlXwnvvGEK3Hhkpc
         BU5OY2UvZif7hCTS1gmmfgW1zwc2XIr881gF7uevr9x/42iegvlD8FnCvI0O3WLLYfuM
         uovEiKXIqv3Rob/iMBmVKlKaxdPLB07tDMhVvWV8u4qPspteCoUng9Ekm2DkzS53uxBq
         oi4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BnmkLIgWSk18hKSD8wtaKdnDH56mNXzkJ0gXdtf3O2E=;
        fh=MDtnZu6N76Ebfdf6r9ElkPeNOTc3pOqNKZDqpZOdzBs=;
        b=PtHMnz0DTALyhvrGwAZy9+T2kWQP6QdBBGbSw2vug4UOzFMW94O4cK3FPpzlv2oXI7
         H1vCJY6TctS1727LYvJqzwu7eRDQqBxmlw2maodkMFAoi0/ElkGngDMH43j9u4Pp/+Yv
         2bm+PJM8ZC/pTducAMhj3XxrxLK7yqOGmmYrShSgi0JOpy+pv3HgVTvAtXt3AfMSrxzY
         SJ5T+ycdoJQgj7vrTQSydpoWyqs+UqoDKDp5wQKIrXplLI4CeNHfQsBBNWtiRBk8hfJH
         aTOUUm+tzpp9a8xEibf4l0yxTbRyP+o97bY9TB6LpsvZjurQO834vBCEI/h4Lsx3kS/8
         zIVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771781427; x=1772386227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnmkLIgWSk18hKSD8wtaKdnDH56mNXzkJ0gXdtf3O2E=;
        b=WCjRzzx6KfSJqqYW83VzdtyLvMYdW8PsT/ow9+r0LzfRGru9LbKcLTrU/2TciFiB8m
         rYNQehnqqVCKN5zafnjuSdNIPlXxusR1AGfr06uY5f8wO2H0vE77fc2XuWODOih+N/8b
         /YKIRGhuyl5+IoLxLicTi0QTEQleXjoIWT+Db35hsYctHSqNdEm+UQe7wE7EE5v+d/yX
         NUPEilzve142qk8qybCt0JmqufMGJDvs74IrsbJYiTrvFayULdcJg0YAeCM3b8ors1K+
         f17gR7/fn/EsHKzt/thiLr94RxqeJDx9jO4SBaYMpwmRB6iFoyNisO3PF/b/yzmDA+6l
         IzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771781427; x=1772386227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BnmkLIgWSk18hKSD8wtaKdnDH56mNXzkJ0gXdtf3O2E=;
        b=Kb84/UPMYYZEajO/X9bWAdW/lTLTAO7MGfx/K7UOoD93nXvNZgQaQT7EXvvJG7iVHC
         04T+tdcWqVefHziCwmiY9bX0LGK7vl9uzkr060keAz+VJPhll/hvgKZrkrtkjUyhcGU0
         fAyebE522Q4MQIiFzeKKFkFEHRyUc4w11E5/fUJKKzTlU8KoAy9Vi90DYTEDUClpulXz
         VqLBztrSsMbvnc+IXucOrCy4jZK35H1x9+ZmMgYyiuQEL9+wha7IKCiP2JjbV1gfXq32
         p6At0OvqW3kbdNJ71BfTl1AaZOS38toC+lxYLzSM6EDYa6Y3Nzp6CkDj98oLh02mylvG
         hATg==
X-Forwarded-Encrypted: i=1; AJvYcCVee5aufn0C2nk3E/OHg6APBJ6AQh98U4f4GqP1va0sXKCez1zpqoNyp/pv6ISLeqs1MVsMte9LRCgSMtU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9yY2hBSs2ZDAkYkquyhk+i37d70j2ZFfmb+ZCGq1DHCcuIoCG
	jpseD1syU6dg6l5VLV/OlPB4HwRsZC6aYPLyBsOsu2D6eJcpRWLis7fFyAmwbLhsqA1Xidnp0oW
	PE92FdQ4LN87/Lsop168RyJ18srL/Tnw=
X-Gm-Gg: AZuq6aIp+m03mo4YvtIInLjtLRWlz75ii5wMb45+niQPPT6MGCzrLOjxnYRHOXmbk9a
	fS2WQccNwXBQZlQQuibX140LfbhdFBHk8ZqApAPK36/i7nhz7tKzQhQh92UgCn8TK3NARshmz3S
	r/REipaJTt7S11EJbA/s3n0NVyT16+vsD8rblmg42Mrk04z7AQfx73+NT51SOEh25kpb7ITFw9D
	gSeQKv7ej/42d6Wj5EWSnTHXzzNfsO7MngXQAftf4JuuUTmUhUrpvTupOxC06Bkt5Oa2ViYFr6H
	W9jv
X-Received: by 2002:a05:690c:93:b0:797:ab72:628f with SMTP id
 00721157ae682-79828fa2ab5mr44574817b3.4.1771781427236; Sun, 22 Feb 2026
 09:30:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260220133135.1122081-2-thorsten.blum@linux.dev>
In-Reply-To: <20260220133135.1122081-2-thorsten.blum@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sun, 22 Feb 2026 18:29:51 +0100
X-Gm-Features: AaiRm50kypTpMDY3ZXdNnlUeMETOr3yH_tAg04sHJcHrEEiY_Yo7xkfaj11LYrM
Message-ID: <CAFXKEHY40ybHVbWLWPjOR_wuv5sV9YYXyum6nTT7LHG+irBpUw@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix uninitialized data access on
 OTP read error
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten! So this one was tested on your hardware?

Wouldn't it make more sense to squash this with the patch before: 'Fix
error codes in OTP reads' (which IMHO actually fixes mainly the bounds
check)? This on it's own I'd consider rather a refac than "Fixes".

On Fri, Feb 20, 2026 at 2:32=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Return early if atmel_i2c_send_receive() fails to avoid checking
> potentially uninitialized data in 'cmd.data'.
>
> Cc: stable@vger.kernel.org
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204=
a.c
> index 0fcf4a39de27..f4a04b297257 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -103,6 +103,10 @@ static int atmel_sha204a_otp_read(struct i2c_client =
*client, u16 addr, u8 *otp)
>         }
>
>         ret =3D atmel_i2c_send_receive(client, &cmd);
> +       if (ret < 0) {
> +               dev_err(&client->dev, "failed to read otp at %04X\n", add=
r);
> +               return ret;
> +       }
>
>         if (cmd.data[0] =3D=3D 0xff) {
>                 dev_err(&client->dev, "failed, device not ready\n");
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
>
