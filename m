Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9067632
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768247027; cv=none; b=TJG71znaWFU/1XwSUNUQfD346ngSbCfeIpmlikVX0fgpKSv7Be3KU9ccTATOUXFYmtkroWhYJTgWfHW+9S+pKdKfenKW+HACeuco9FgJgSaZZR07e4B3FyRSdwZSZHNr225ykFMp7O3sZknx+L4Z6itxj8Xb2twvT9An/x8T/IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768247027; c=relaxed/simple;
	bh=MAxVjP6c4Om6u8vsm6jVY6NUCkgy7e4h2yG64mnXs5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WqSqpyOF7CyMZ+GW8LJL9Ls8HlZHFwWitmAmEhsGLD/gVwhUkq6i8QZ9WHfjpqn7BHv86G3sRxg0VahR+GVvDtQj4cI9CmSzI2c5exyUPpDH73Rxkoenv+7xnEuP8nD+W9tI1yHbicnXwX5QAgbCRlqbatek0nsV/J4s1wzv/Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVyLx8NQ; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVyLx8NQ"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-11f42e97229so10475970c88.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768247026; x=1768851826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAxVjP6c4Om6u8vsm6jVY6NUCkgy7e4h2yG64mnXs5A=;
        b=eVyLx8NQsDXwFxULbC6lIB8aRSFZssJy4HqpWRrlKnX3I6McmdO1XXMQR0zlHqDBbz
         6KsDmNBBsWAAzmWAdG+UGE+X9CriTVZafVKTzhrXf1pRlRMFMzYBR0j3d8pltOZvcjeG
         ENNWb0dL+yTqrUBfkqve+Tpdx5oQPL99zANdQNfGlzFqixXIj6qEg51N/eOiUizQqj7X
         J444QhQaCyym2EwyapBFq2yE3iwjpJdJDEV8eEuraHMNfQEymFNdbCIqqXct5wpHq6kJ
         2qGDcX74iNoRdjaODIYkoenmmtfxdVjIe7sN07dRNL522Qrg2ENdXA44DMKuySOZvRoU
         F+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768247026; x=1768851826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MAxVjP6c4Om6u8vsm6jVY6NUCkgy7e4h2yG64mnXs5A=;
        b=WDAmiSfPkhGNWsQIp3vkJkAGqP+mUfjkDVm3GfHAvevDU0hHoVC8OKaSbz9xgH7Bnk
         rGpVPioqT2mC3NmvyB2nUtI8/+9nNCORV96xc6vEmxdVqHQ2goSgQugHEjrI2uIaCQyx
         jyAUDx6O016L3oBnV9uy3o/TxB5cxb7/jj4sjbrL4StE0Vn9ZPYLAMumvFYUrSELZ17u
         C0xv3TmMZbNGIHj1nkrcENZf+tEzhCg7Tb4uK8PIBHksvmAXmwk0lH8+cAMIfsqlRpoU
         8Q8eNhqT+Z2UyhPc4cyatHfrhSq+hDWNToh9GJriY/qXjn315Q2D0KjrbFIKQnv90Qhi
         iflg==
X-Forwarded-Encrypted: i=1; AJvYcCWxzVSmFovH7Mmm+w5oTq5hIbwetkKznxPNJaLpA99sDDh7ct3y5N3YphIbHPoAHq7nRLX57hHm/M16CW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdPncQrQiGEoSqvkrcHhaTY5whBYLDE4fMwWm/XoPpVkam7fEq
	vnv0fFr7V42zXxlRpgTrDnoyrBXgRhiKqT8VSKPcwEeh/ZyfU75mGLmfP75G2o/i5urKTg3agjH
	UrfTI+78JClXaPh15dAL+3zw/sUOAunE=
X-Gm-Gg: AY/fxX74FfuTHZ4o4pEzfCwM2iokItOAfTjswjE7qaZU++soCwUO2W6DHxprn26J/IF
	9kJv3ZLCs2gARuzjmSmNKv70NK+d9J9aFw5K/g9sUjZ2D28qU1xsLTLcqRRfKJnK0vCKb4YhAOP
	NobakXhcw/F+KlvICTf5OQHLWqnKZvTm6ebWotuVWzyQ48g8uz9zZ7aLN7Zi3Knv0YjN0QsCgD3
	Sy58PVVc+kXZeo2BWu96yUU7IFTY0TU2NXUi/Cqyw7UQd2Yye16j9d1W1KgwZ88IFt2sKMv
X-Google-Smtp-Source: AGHT+IFh5tn+kU9IHfrTDs0YlDSC03bvGBEomnygmpEiizRJP6bN5S//rn0KLdIYBN2zkqKUpA3Hh5rzgVkX84e+Dw4=
X-Received: by 2002:a05:7022:220d:b0:11b:ca88:c4f9 with SMTP id
 a92af1059eb24-121f8ab9c96mr18145001c88.2.1768247025780; Mon, 12 Jan 2026
 11:43:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Mon, 12 Jan 2026 20:43:34 +0100
X-Gm-Features: AZwV_QjnGtbKh0drXweXXMzt0JXRbTQf5yAyudSCZCAyLdJxE_GC_2wiEvkNplw
Message-ID: <CANgxf6xKrawktF4wPQOs08q5Ob9N_Ff7-=f_hRiZ9yKq4LN0oA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: ethan.w.s.graham@gmail.com, glider@google.com
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu, raemoar63@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>

Adding Rae Moar to the thread (rmoar@google.com bounced).
