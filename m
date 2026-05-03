Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42077279DC9
	for <linux-crypto@vger.kernel.org>; Sun,  3 May 2026 03:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777778326; cv=none; b=jkqA3yNE8OxXJEZXz5BNl6mAaqUyWfJq7TJfQqZA0X73wdvEY00yd5C5auUJBNBLUhbrwC36eUum9xSCaMWjd3IrIuM0FWXblHY4oYJnRmUPNQevARK96hAcn6mpBOykvN4qCQNAMHqgki9poeRzqn+hszXZqloXfyikfSk5yg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777778326; c=relaxed/simple;
	bh=nmCIRQtmzPaozAao7hOSorsx6A6W5yoKwH9m55zMD7c=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=MKwEwliwFV+i2sVGWvBcNjsqUBRvJ2DCHA03WwMQzJARc5KXlB2kWWEi4tYpJ1QZpnWJXIwPTr+/IY7syo8KMhM/kwgodf4SbjcT9YC3SSQ83hXGE8RSvluaO/+9KiqkeDB8diCtHIO7Du7W8SeFk2zExFlTrqq8jND1SG542Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExJ3t0EQ; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExJ3t0EQ"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dcdd1b492eso3268107a34.1
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 20:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777778323; x=1778383123; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqUhwWS39NFCpywsYbpQsNKLdN9sC3fxSRnSGZPBknY=;
        b=ExJ3t0EQgY0Kc8l/vNira3IVihmNCwOVYTfRlPa3Ij4AzWIPQFfJQQq3tf6VYAwdJI
         A3o14Hpp61OSS7MKx+PEm6n7QcZDmJYMzd6TPHtzR9SmjutPF6xvQe1XxYE074yheuPO
         CStfCaDB+GQRZGXMv6nT9y57fgUxzn9k6dbyifB2+bgpgVfS5ZS3/xv6fk8+qmg/Fidu
         qwVJqwDZUc+Ia/UfljICkrm4voRJwJeuWFxurItleMzA8XkdCZYaqhGfMBDf6pi5fhK7
         Tl0VCBJfOKD430ViNjg9n+eJubuodZhsoZb2fk/sBXGHlOxIGvvvF5VAhD554gHs8IVG
         8RMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777778323; x=1778383123;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XqUhwWS39NFCpywsYbpQsNKLdN9sC3fxSRnSGZPBknY=;
        b=sN7nihsZYkbgvPDRN/fC3QTLzlGqCmwEbS/UoIfnIh0kF3Ur9/AmOuqn8ZfjYE/F/i
         JxkKEaoUyqZ1+zbUScIkg3j/lAMJuFhFw0m8jtk69DWw5yYLZ0faldkqBzdvKPrd8vny
         e09Ik7Bg0LMuLIh/+bIJw1llpq+Zw06bsekf8nkq1R6rNyuUSF7CnlNCyYbJcfZtczwy
         G5S84WAhbxtr3X7rOfp4Z6XM4XPxGXlIbZjEFzcPpbbz5VXmL5K5b6vXsx3FgA0K/E4/
         w7rpGjD8PNuMXzOafTmqhaornf561EbFc/D/jIMUcNgr3lwnQup3KweCeUMrwSvKjduk
         EEnw==
X-Gm-Message-State: AOJu0YwpKuwW0gVg6AI+Nny1USl+j112I/ZMSLp9WWaccWc8PcsGAu7/
	EwYwdgxi1BYcFn3TARjXKT0qXnDdEVqV7q/zVrQVqQhkonGLarAxrnYF
X-Gm-Gg: AeBDieuDHIE5hn3X1SnzGJPbZQzcUQIRVE/a6FwH0ON+b7fMkwu0NlQiK5wy0hz0tWN
	uXVBaXwwL3T0GlZGtVfYhycYHxona7RDV1K1ghECt+MyP+EwAbDxITsXiA3snXxpq3E5U3Ov8n/
	PgOB+b+GiE40LuYilMoTsYtWlz5ggmLoAiYJne2QFf7o56VMfeIQGZs3s5FQVFoEkITUG8ai4HG
	TM1DHkjoSQX3KidAEAw5ic86bdV5JNTjpClvtHkVB+C3JUz9NuhJQ9NwsrPbV3AQiiHDo3KMO88
	ESF6VufV3dP6zlzhGdVzfd4J/R4SM7kqO4lc3VTJI0jqEjofLvn0jS126uS4Gidy4+EgEC0WnKD
	ZfuhW80QjeWPIeLRlDm3HBedW6C3vwq4FXPaJAjtziY/CPGcwpvIZiyN+EhMkPoSGro74DidXpS
	Ru+U3huXmy7xdumRPzbtlCXWh8/khwE03aC12GEYpWv0KYxjnZnb/Ve3OVb5/+
X-Received: by 2002:a05:6830:1186:b0:7dc:e2ae:c15c with SMTP id 46e09a7af769-7debe39de18mr4210891a34.16.1777778323221;
        Sat, 02 May 2026 20:18:43 -0700 (PDT)
Received: from localhost (23-88-128-2.fttp.usinternet.com. [23.88.128.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deca80d5b7sm5278512a34.9.2026.05.02.20.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 20:18:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 02 May 2026 22:18:42 -0500
Message-Id: <DI8PTIGP3I43.JOF10O9FPOMF@gmail.com>
From: "Maxwell Doose" <m32285159@gmail.com>
To: "Tycho Andersen" <tycho@kernel.org>, "Ashish Kalra"
 <ashish.kalra@amd.com>, "Tom Lendacky" <thomas.lendacky@amd.com>, "John
 Allen" <john.allen@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Sean
 Christopherson" <seanjc@google.com>, "Kim Phillips" <kim.phillips@amd.com>,
 "Alexey Kardashevskiy" <aik@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>,
 "Pratik R. Sampat" <prsampat@amd.com>, "Michael Roth"
 <michael.roth@amd.com>
Subject: Re: [RFC v1 6/6] crypto/ccp: Implement SNP firmware live update
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260430160716.1120553-1-tycho@kernel.org>
 <20260430160716.1120553-7-tycho@kernel.org>
In-Reply-To: <20260430160716.1120553-7-tycho@kernel.org>

On Thu Apr 30, 2026 at 11:07 AM CDT, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
>
> Put all the previous primitives together to implement SNP firmware
> live update via DOWNLOAD_FIRMWARE_EX.
>

[snip]

>
> [1]: https://lore.kernel.org/lkml/20241112232253.3379178-7-dionnaglaze@go=
ogle.com/
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 244 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 243 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b4711bf823e8..e7fe6dbf69c2 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> +static int sev_download_firmware_ex(struct sev_device *sev, const u8 *da=
ta,
> +				    u32 size)
> +{
> +	struct sev_data_download_firmware_ex sev_data =3D {0};
> +	int ret, error =3D 0, order;
>

Why not assign across multiple lines? How about something like:

int ret, order;
int error =3D 0;

or:

int ret;
int order;
int error =3D 0;

Would be better for readability and git blame.

>  static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_uploa=
d,
>  					      const u8 *data, u32 offset,
>  					      u32 size, u32 *written)
> {
>

[snip]

>
> +	old_major =3D sev->api_major;
> +	old_minor =3D sev->api_minor;
> +	old_build =3D sev->build;
> +
> +	mutex_lock(&sev_cmd_mutex);
>

Why not guard(mutex)()? You used it earlier in
sev_firmware_reinit_if_shutdown().

>
> +	*written =3D size;
> +	ret =3D FW_UPLOAD_ERR_NONE;
> +
> +unlock:
> +	mutex_unlock(&sev_cmd_mutex);
>

See above comment.

best regards,
maxwell
