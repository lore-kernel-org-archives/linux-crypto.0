Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670D7839EA
	for <linux-crypto@vger.kernel.org>; Fri, 24 May 2024 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716537492; cv=none; b=f0Fac9LZDeGiQmBpgelSxPfoYsRak3BRaDzO07Fz7iWsJuebRVGkUlP5dkSvvqOZNCfXiwVn4M/vSm+grQI5SKZzlciVzzvEd4fvbw5+Fc5p5PcPbmCO1R//k1Ju76KjKZP9kH00GSwpzqbNCpL6LJe2zZKC8pAMJ1ilNn3Z4DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716537492; c=relaxed/simple;
	bh=j4SguOp5DOxcin9YMQbQ4KVjYAfwfoDRCgjll5pJVhw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XUK6qic972BfJ9Abok03Kh8tpyZ7YZOivwDQF9pmMEGJI0uwUT3BE25XQwjDEvIl8e6w4RPBBlssFJg9OKc8MWG3LdWb9qHqbfFqkgb7Afua2sZDbYQxE+9DUel8bfGqkxhdW7ZsULDCoGgy+BxGhJ1Dv7ErX7+8/o5jOZsAO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gho21PgG; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gho21PgG"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4210aa0154eso1066295e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2024 00:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716537489; x=1717142289; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJ5mXrUPGN9ArVhdnW/kXMjv+Rf3Fj8nFbMbq6dtORc=;
        b=gho21PgGrY4XEANnHyfzdRQ6LBz+nAPuKewfHEqwbSUpHhY5AejhpimQl/e4vXJ4FA
         BXixbyi+4+eAWmN3J6RnSEzM5UQ+0JM80H+FgPBEpzLTHowfClsPItKq5r5HbX1HYSHs
         JTVLtn7+jBLrkjIut2tzTHawhvyDahf0xl0LrLekNqGKMgw7QK9bh1XVo33ZQoL8PN40
         qbuA9jp3ej2jMJmzDcnghKEych7ciYJ3Zyla0pGkva0lNd8q0P5XwaJT/SUoSSP0AoWo
         O+5sDbz3D9WBZq0DfYeynRyCb3vvHtOHY+pj36nvYzbmHS3Sn4YgnK3vRLKC6ryvV87O
         ocpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716537489; x=1717142289;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJ5mXrUPGN9ArVhdnW/kXMjv+Rf3Fj8nFbMbq6dtORc=;
        b=UO6mOQLeFSdbUiGO7loTumqWIYv6zXvPXEjSJ+s/zubj/0Id1WMVFf15HgNaabywCh
         4m8ie7/9UCImUCNXFXRvM55cefVbDUvVubUCUqQ6+SFmOOG/Sqn83UaHUfooUFenpq5h
         KFUaZxC5AxEG6NibACqOLHU3dvlevLouOpPjPka7MWIgukA3pnp3csxL2jj0G4p+b8ab
         iUml3xsxhweAxiHXDTgrjndFiO+7LX8HI79FnXZngjJls5BKPdWHtXHzaNJ7icJY996w
         aMiYLV/oOyqI4YPPE1lOF79Cm09AlDOkhmHkwtfu649k5WFRP6QuyDPWGHd/CBpFNYRK
         yLcw==
X-Gm-Message-State: AOJu0YycU2RQikTPhf9hdNYyWo8E/kYlUt0S5KounNe6IqTpK94n1UDu
	vg3KDDa19Xhe7QewtTUML+6CADTn/Yu8HiMZXLbslEeKpKEz28mciOBoW82NORefMf3V2Y8Oabs
	Y
X-Google-Smtp-Source: AGHT+IHblURPVwMQkzB/dzNTsZvlLrB1EJ8J6dd9ZQeRa8B75wkyYxY+R3j6N/h7AfMlERHDnNyzKw==
X-Received: by 2002:a7b:c44a:0:b0:41a:8055:8b89 with SMTP id 5b1f17b1804b1-421089d50a0mr16589955e9.6.1716537488575;
        Fri, 24 May 2024 00:58:08 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42108989fdesm13320285e9.25.2024.05.24.00.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 00:58:08 -0700 (PDT)
Date: Fri, 24 May 2024 10:58:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: l.rubusch@gmail.com
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: atmel-sha204a - add reading from otp zone
Message-ID: <34cd4179-090e-479d-b459-8d0d35dd327d@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Lothar Rubusch,

Commit e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp
zone") from May 3, 2024 (linux-next), leads to the following Smatch
static checker warning:

	drivers/crypto/atmel-sha204a.c:109 atmel_sha204a_otp_read()
	warn: should this return really be negated?

drivers/crypto/atmel-sha204a.c
    94 static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
    95 {
    96         struct atmel_i2c_cmd cmd;
    97         int ret = -1;

ret is set to -EPERM here.

    98 
    99         if (atmel_i2c_init_read_otp_cmd(&cmd, addr) < 0) {
    100                 dev_err(&client->dev, "failed, invalid otp address %04X\n",
    101                         addr);
    102                 return ret;

It would be more readable to return a literal.

    103         }
    104 
    105         ret = atmel_i2c_send_receive(client, &cmd);
    106 
    107         if (cmd.data[0] == 0xff) {
    108                 dev_err(&client->dev, "failed, device not ready\n");
--> 109                 return -ret;

atmel_i2c_send_receive() either returns zero on success or a negative
kernel error code or a positive error code from error_list[].  It really
doesn't work to mix them like this where -EPERM and negative 0x01 could
be confused.

    110         }
    111 
    112         memcpy(otp, cmd.data+1, 4);
    113 
    114         return ret;
    115 }

regards,
dan carpenter
