Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="LQqpKlGZ"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D25D135
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 23:02:46 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1d04d286bc0so31023885ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Dec 2023 23:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701846166; x=1702450966; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fu+2zCulSKmRYIMjAz25mOHD/VLglGiacC9LPzc0jW8=;
        b=LQqpKlGZ2nj0z/klZd8QA+itG40Eh/Rj0ftok6dhRTbQDS4cKg8UPdFaIrEh1UzfcL
         BWxU6Y4jDuum23mWltVMMACbAPRGQCUmetoctflXmZCV/XcZxjKf51i/F3Joan5obhrz
         8YJ94eYKbJOgdUvDtYsYnXOG0cHVh7XdqTMEZ0nXHoKCOPPaQgSPXfK3GM/DRWrKO9AP
         TdNJtcApim8K9yyrWsJsCDL3ElizdCD1Km2P7DimionnHzKVAViIo78gSKn4p1F0Pe6/
         eMKFsZprtOZqvLYVeSASOsZjIuXrX+oWMr+RoF/x9g7JBYiSyTLO7oJfRKw8/1O+uQ+N
         Dzww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701846166; x=1702450966;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fu+2zCulSKmRYIMjAz25mOHD/VLglGiacC9LPzc0jW8=;
        b=uT5kAZfc/AVfLiSphPxup5Xlm9CYhG+EMyL/MDFUaigtIfKiQgxMzKt70zdTZ5gV0X
         A7KhQXBlJcwwdseerrqU5yfOcnsdTyXl5TFkUVzMbP5qysF162R0sSWxCItbyoxORhA/
         9Y+DxwT9kjFZfu7y511HXPgvz+EuVDfHW6JSlcx+YyEIkGRrTFqIa68+mClmfgS+zoRs
         SopCSTp4Eze7g1eJkm/T8OwIAotwPc8A8izYs3cdP9plL7wPM+dy4LurnS64kReYSW0l
         pF4OWJC1HiVNSs5LHpYX3tcFoxx0jTZK+jjY4yDARIEphMVpFXrypaRzmi5UGUGY8JMR
         OBmA==
X-Gm-Message-State: AOJu0YwrSDz2+Aimoi6OjfPlpETL+deUMJyjzP6bxBGTAjYACJPhThPa
	q59uljg8W69Hgj+hSrnwnuciew==
X-Google-Smtp-Source: AGHT+IFutllwNx0W5P2v7t+uVkRlQHqsiAuymkq135vI7dgBN2unDgIUr+uxElxPzn8LDzhuHQ4wTg==
X-Received: by 2002:a17:902:e5c5:b0:1d0:6ffd:cea3 with SMTP id u5-20020a170902e5c500b001d06ffdcea3mr223805plf.92.1701846165671;
        Tue, 05 Dec 2023 23:02:45 -0800 (PST)
Received: from ?IPv6:2402:7500:4d5:3caa:a552:1ac3:8952:64cd? ([2402:7500:4d5:3caa:a552:1ac3:8952:64cd])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902dad200b001d0c37a9cdesm2591565plx.38.2023.12.05.23.02.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Dec 2023 23:02:45 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v3 00/12] RISC-V: provide some accelerated cryptography
 implementations using vector extensions
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231206004656.GC1118@sol.localdomain>
Date: Wed, 6 Dec 2023 15:02:40 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 conor.dooley@microchip.com,
 ardb@kernel.org,
 conor@kernel.org,
 heiko@sntech.de,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <434A2696-7C9E-4D13-9BEE-25104D37E423@sifive.com>
References: <20231205092801.1335-1-jerry.shih@sifive.com>
 <20231206004656.GC1118@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Dec 6, 2023, at 08:46, Eric Biggers <ebiggers@kernel.org> wrote:
> On Tue, Dec 05, 2023 at 05:27:49PM +0800, Jerry Shih wrote:
>> This series depend on:
>> 2. support kernel-mode vector
>> Link: =
https://lore.kernel.org/all/20230721112855.1006-1-andy.chiu@sifive.com/
>> 3. vector crypto extensions detection
>> Link: =
https://lore.kernel.org/lkml/20231017131456.2053396-1-cleger@rivosinc.com/=

>=20
> What's the status of getting these prerequisites merged?
>=20
> - Eric

The latest extension detection patch version is v5.
Link: =
https://lore.kernel.org/lkml/20231114141256.126749-1-cleger@rivosinc.com/
It's still under reviewing.
But I think the checking codes used in this crypto patch series will not =
change.
We could just wait and rebase when it's merged.

The latest kernel-mode vector patch version is v3.
Link: =
https://lore.kernel.org/all/20231019154552.23351-1-andy.chiu@sifive.com/
This patch doesn't work with qemu(hit kernel panic when using vector). =
It's not
clear for the status. Could we still do the reviewing process for the =
gluing code and
the crypto asm parts?

-Jerry=
