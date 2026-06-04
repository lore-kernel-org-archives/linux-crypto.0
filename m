Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ECE37CD39
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 07:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780557785; cv=pass; b=eDmpKpVqF0QhBRlLNcFV2Dsv9usOyV2jr3dd9Bh09RE3omf9QOcLvoHZfgfmhOj4kBa8Wgm8hF6hDt/GRxZ9Mj9snR5TFqZWWe9UB3tWRODisnKeV1YmYfiNxXC4pe4nL0fSVyfx+zqEPm3cRy/rVnyuWyhdIAqxRnRwopesVkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780557785; c=relaxed/simple;
	bh=kGMFrm6EMrXrVFbpoOcvMp4m0AfriiOIio3hMd6Tp4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y9rqmQ93NPGx1vzf30jtMggqY/kGqVPB9hG9O6D7y/bz8ieNuwFkksxKShnYLcY9UF233WCGSm3t/SQS4pCdPJvG1oChHSeFchgneuHiZ0QXuhW003V1GIrRpqFMb4s55xiu+DL2Rjc+hqd/aoRCeGcfY/7yYgAXj7PC/ttURuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPZKk6EI; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPZKk6EI"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7df68e68103so512027b3.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jun 2026 00:23:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780557783; cv=none;
        d=google.com; s=arc-20240605;
        b=JbWV3U3G0ffb08Qe6qT5ccdSQL2Owje9vC/W+es7fCcFgjq5RX4PKyIz3y/EhcxZEe
         GmwqmnIx946IZBd9cB10YQGvcDkD4zEXsT+iAnwJ5UFcsKNo6KCAVmqvnkbpzgGmH6zS
         /nTPqToaXGEUkK9AjLUq2PdBsut1qa6ArskA1STKiEdJmVHq9WcEV4dnLgYli1tk5gzf
         1jsDwPjPH3F+g/D2+A6NFF+QJnF4nwU7UsnaPXKefR8pMMHsPgQyea3mRtL6n3dtkvn7
         v81pZfYIgi4D+JbqptCc4ry/CWikuyXoQr5pMSpmIXkDyayY1wsw1T9t6rxwjjTr261t
         wx9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kGMFrm6EMrXrVFbpoOcvMp4m0AfriiOIio3hMd6Tp4c=;
        fh=wZQrBoU9yM2p+3+5YhzYIP/V2GgSjiX60EZFpJOkInU=;
        b=ShlUtwa/vFll8z4CeAdGCzlfZhAMV/eYQBYwbXxJWWCpIX3zHF/oYGFvGOZO1I86bX
         yQKpZAs1fCu38ZLGCwz5sJbqkX/9EeiNG/OFJVQxVgG/CCKeYQ2xHA74QqSjp5tFrN8v
         nBY9fveHZhnQPxtqSJlxSZb9W9SO1gRY7a/5oUYh93pIBRCxxhyORq2i7Sktq86lEPsu
         EVkOXXMl8+K5uVgEKRprTIHh16Jpt8EVJsuKM8AxXUa2SL4Su3/XoN3hm/A+vtBx2nVY
         Gp/e+Oh7WF2N/yWyoVYPn4N8DCCeV8OGnK+iAzZz1iR65NvaHmY50Py2bkOXhLjtoIfU
         Ikiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780557783; x=1781162583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGMFrm6EMrXrVFbpoOcvMp4m0AfriiOIio3hMd6Tp4c=;
        b=iPZKk6EIKQlNhrvmIRMASrX9FC3ORpuGlyFD/PtWLxm9BKRxKzYDl6XIabWKiIgTk9
         voZk+RUhdKkPeLve9gX5HNvWk2f0lqQ0NWwPB8+Mviue6ncLEJ+7/5gt2EKyFnRWqiS1
         qSqIPCZ5jjsZH8vkjXScvkI3HiQ8U2g2DXXUaQoIWKikNxGyyLILAoIoLgu9W3NOSArx
         pVKvXUsPEjU4wciTG8kEvPFn3qhY55VudXEwWo20qAehmPv/0zpD/2X1JTev36D9iB/7
         8mZ2MG4qowmV2f/cxRjjiaDVtnkJL0aNlnAznKqC7A1Ygi3bx+eXoafslzHw7KugF7lx
         SPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780557783; x=1781162583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kGMFrm6EMrXrVFbpoOcvMp4m0AfriiOIio3hMd6Tp4c=;
        b=nKqTOIPl0pT6vcrnlIZq9vIR7KLJjjclj4At7y/jyhN6wY2n8QPP37HhjlAhXQlLjI
         B8qNisAksFlVAPATJWzS2LRh/1psV5sS4Jem5/3n9Ppg9d+pk02hkDMGNiZqpJPvK7PY
         7WHxwkxGFWpCPUfTqTbVUdtTTsCxMpAsa7fYwNOBU2ELdHgdK6IgdD6YX6cRk887xfZE
         fdLEIP7y8VNCB3vGkTprIx1CGhiHzXs4ZKvwLOPh58b1pRDOO6M5Gwqag+mbpUTs0vNE
         uKZp72YNazo2uX9NI5Bognfxe5Fyx1X+u8GRsQxtXaZsZVuUkeh4uDeA+WRJDfomAvPJ
         rbnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+T/LvMitL+aOe0j9CR4IWOxO+hLEHpucpEH1kx5rEE4kx1Xi/vCFkSxUz9B9j06AE9tz4XhTkgtwrhgdw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb3L/kHRK9bDxgLEWpRxg5zLYxOSaxj+wiQ9l6RG2PvYcNn7uP
	CnkXbL3l7/P69FVThj6JUjMEjeViuUwb7dIhhpIMnUmA4I4BoC+zOkQOLJG+y1zLkTjvBUExhSw
	Q7T90/3ATo4jR6npo7pkEmpPQeP9x/+n3BA==
X-Gm-Gg: Acq92OGpRaQ3UNlclW7dwqqv4W1k1LujFm9T4Nvsoxqbqfl9er1JtdEqRmo0lLlroIE
	d8vXVXK60dKDRBD5xQCpsEgcImhFV8nByTSHVbU2Qkc+zW6ShNZi/+DWJYDiBvVHnHUz6IqzlM0
	73r2d0TWTararuTbf5sEPc4lb+VPED64wqB+6qYm19ieIDwy9y+FhPXf47pfsImyEbtXpoVuqDi
	2AEb3MGEx4zj+KgfrTuEvZRH2LbDgKFDeBIdEGM2jTNKYVuo7dLfFsVfVVL5ousnGe8zH5sYIhC
	7agsJKWsVyADh50=
X-Received: by 2002:a05:690e:b4e:b0:653:1298:2757 with SMTP id
 956f58d0204a3-660f40fd7eamr810427d50.3.1780557783018; Thu, 04 Jun 2026
 00:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512224349.64621-11-l.rubusch@gmail.com> <20260601090329.52616-1-marco.crivellari@suse.com>
In-Reply-To: <20260601090329.52616-1-marco.crivellari@suse.com>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Thu, 4 Jun 2026 09:22:24 +0200
X-Gm-Features: AVHnY4LwRu92F53BArrCe-tkeP9ej-aZpiASNoZK4Sv5BA0YGwuO5g8QXL7iscc
Message-ID: <CAFXKEHYS7brYaz0ROMfj0gJUc-kHW+M04WG=_BWPaM3an6TcAQ@mail.gmail.com>
Subject: Re: [PATCH 10/12] crypto: atmel - update workqueue flags and add
 flush on exit
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, 
	davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nicolas.ferre@microchip.com, 
	thorsten.blum@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marco,

On Mon, Jun 1, 2026 at 11:03=E2=80=AFAM Marco Crivellari
<marco.crivellari@suse.com> wrote:
>
> Hi,
>
> > Update workqueue initialization to use WQ_MEM_RECLAIM instead of
> > WQ_PERCPU
>
> Not sure if you're working on this series right now, but this must keep
> the WQ_PERCPU flag. WQ_PERCPU has been added to mark explicitly mark
> workqueue that are per-CPU (it is the complement of WQ_UNBOUND).
>
Yes. I plan on splitting up the material presented in this series.

This particular patch was one of the things I was a unsure, if this
actually could be done.
Therefore it was already separted out. I highly appreciate your
feedback. I will drop this
change and leave WQ_PERCPU until I get there.

>
> Thanks!
>
