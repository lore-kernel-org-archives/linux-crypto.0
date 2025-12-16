Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C760E325705
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765904415; cv=none; b=XfnfaEE6wpMp00+imPvcta15uFF3i49Qt914b9pW6CR8IgKRaqKbQSBqFwZ3ioTqDraagGB7BOMr4IuoSuiRsqnoQ7sHGLsB9kfHjOxH4a5JwqJ+W3/0H5uhsfaMe6COA7humB6jc/zpVlkL8ygofFHtXjxFC2+lkSEgJyn+iTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765904415; c=relaxed/simple;
	bh=3IYSY9PEuKyOHfJY9QUPzKffXbog8qESM1aHD/icEQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ms2kdhbhMbNIgvk8mV3ec9uwmanMlbm6M3GDLVIqEzMPaEuNQbvpEdROSFeIyOg/dBn4TDiuynkJx8ThzH0V73R8LacKaU4hAbM3Xhz6UN566ae9q6hS/I3TW9TrEWTigP68dovKLGfGFyhE1qvMtbbYnWo9APXwan84DbfLiiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=uLbYzMri; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="uLbYzMri"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b76b5afdf04so821668466b.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 09:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765904409; x=1766509209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IYSY9PEuKyOHfJY9QUPzKffXbog8qESM1aHD/icEQI=;
        b=uLbYzMrikJbXrolr+nmd8GSQvVajEW2UEgZcKqPe98hLq6969czHgw88r2gKgv9n5u
         ixZqm5Wo6D1T8G67PuoT1Pimw9a9H8Gng18B+7E8HTMjw56nSu1yz7gDHw+g+vmRSKLr
         gk0/g8Y+x/aWaCUqxrwE9zDC5PD8LV9bGzo87ea8hL8QgKCjEm4k2rA4fDNMuZjdh67E
         Lox7A5otoQz5W1IywzHMQiIHGRqUiI9nJtEW8Cx4k4A/B/guEyElge9f6iEfVJEdC0ux
         j6abMKT6eZjDeqEBa22QNXgQVQsab+JFiVeCrui/Jnd8iWbRdR6hnfFf4cCZMy5cI6ar
         P1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765904409; x=1766509209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3IYSY9PEuKyOHfJY9QUPzKffXbog8qESM1aHD/icEQI=;
        b=hEEOSIgRy+wzlW/B7m40IRUHfwxL+AwjJ2F3zumm0zjsqD5w3yLm/KFxFdNbhoVVGB
         aGZqXHE0YM/Nti47sKuWFJ3qUs2l0jdsJ5iqrvBJLk0bxtcifztT00W0jkvGHG9eZcDp
         XCPP+oZbKaMR6Rf6+mNK5znbIOcjBiWBTz944Qiy8XBb4QE+8CtH6kM5NWMzrDjAC7ZY
         AHB1MOR7VtCX5d6f8mP33TgfN452tQpvuAVvVPUsh0cQmUIMmBD19dU+kfAIKWYAem//
         Gp04nlNBVUHu159YwJLNcz+2iUCd5NqZ6m73mB8tflJH4ZX1bRV1b3N7CaMKhBuf8jLf
         o5Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUGCNHFBPFuwNl+IXijaRigywFsAm7HzUZ5olWPTanBSkD30dp3e7cbm3m2e0UrNeb4ZflvioLhWdhyHPI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxllvw9Itn9eWLLLBlQWLNrxvdieJSr+SFSoc6SokZ5LE+7REv4
	f25ZQDQZXI3ZV2GWK+l4oGsWGSx4X+CpK0fgRKDoXJmD6Z1PG8yS2vzoVM/xgX7y3s3c20R1Z+3
	CNegsYhG2RkaY6avfH8JbhPyMfq95sraS5zggdlqxXA==
X-Gm-Gg: AY/fxX6XoZAf1Vj8E7wag8V5CjRyq3Y+5iNe4ggxVdxCRZvC/2xQ3AqJ/WudHLSdNs5
	z7hv/nM9TRiclrcpSTW9zWAyk8LvsthVAh5g0hfu+DQ1Pn6YJ7CZkVrjkLtA3QbzQIHxXYW+FkD
	SOpMMaECiYE3TKSnQZAtmVUVDlzDzAyR39xjf6EUhLuaoFwTdIilCOJmMRUDbuIVwBpHmmlmJNz
	oqcHXAARGDoS6qShE7cVsUepz5fVNdVz70fu958HAdW9Js0UCsk9FqYYSh6Xa/XUQdiXpTS
X-Google-Smtp-Source: AGHT+IFwk4Ao673gGD7fsG2ghKfE+CBJxlDalRvkjfP0dfzZsUtUavnidDCo43zIGnGvG5i0aqfY+tiPySp8HUjss5M=
X-Received: by 2002:a17:907:3e1f:b0:b76:f090:7779 with SMTP id
 a640c23a62f3a-b7d238bb030mr1612478166b.33.1765904408497; Tue, 16 Dec 2025
 09:00:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215163820.1584926-1-robert.marko@sartura.hr> <23e02efa-bb94-48ba-9b6c-acee5d8f6576@kernel.org>
In-Reply-To: <23e02efa-bb94-48ba-9b6c-acee5d8f6576@kernel.org>
From: Robert Marko <robert.marko@sartura.hr>
Date: Tue, 16 Dec 2025 17:59:57 +0100
X-Gm-Features: AQt7F2oKQzHSEY0k9JattjchuSq-s1wqnAD6k9L-CshDVUNdGCLvRtWCtUFfTxw
Message-ID: <CA+HBbNG9wcDTPD8GAPVECecUN8maSvTyahkxaXsHqzLY_8aM3A@mail.gmail.com>
Subject: Re: [PATCH v2 01/19] include: dt-bindings: add LAN969x clock bindings
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, Steen.Hegelund@microchip.com, 
	daniel.machon@microchip.com, UNGLinuxDriver@microchip.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	linux@roeck-us.net, andi.shyti@kernel.org, lee@kernel.org, 
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, linusw@kernel.org, olivia@selenic.com, 
	radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com, 
	gregkh@linuxfoundation.org, jirislaby@kernel.org, mturquette@baylibre.com, 
	sboyd@kernel.org, richardcochran@gmail.com, wsa+renesas@sang-engineering.com, 
	romain.sioen@microchip.com, Ryan.Wanner@microchip.com, 
	lars.povlsen@microchip.com, tudor.ambarus@linaro.org, 
	charan.pedumuru@microchip.com, kavyasree.kotagiri@microchip.com, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	dmaengine@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-clk@vger.kernel.org, mwalle@kernel.org, 
	luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 4:57=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 15/12/2025 17:35, Robert Marko wrote:
> > Add the required LAN969x clock bindings.
> >
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > ---
> > Changes in v2:
>
>
> Where is cover letter for this patch bomb explaining previous history,
> giving lore link and providing any background/rationale for making it
> one huge patchset?

Hi Krzysztof,
I should have made a cover letter indeed as it is quite confusing.

I did not plan to add all of the new compatibles, but it was requested in v=
1 by
Conor [1], Nicolas [2] and Claudiu [3].

[1] https://patchwork.kernel.org/project/linux-arm-kernel/patch/20251203122=
313.1287950-4-robert.marko@sartura.hr/#26687201
[2]https://patchwork.kernel.org/project/linux-arm-kernel/patch/202512031223=
13.1287950-4-robert.marko@sartura.hr/#26698565
[3] https://patchwork.kernel.org/project/linux-arm-kernel/patch/20251203122=
313.1287950-4-robert.marko@sartura.hr/#26690625

Regards,
Robert
>
> Best regards,
> Krzysztof



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
