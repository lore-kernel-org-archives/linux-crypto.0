Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54940BCD8
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761101; cv=none; b=QyTCw9FTedtxNKPqnqtI9N9oiYYMeR/X4e4O/7oMS2tCzHKRydFfjg84BtLCtNd9x1IDRIi4LOhZaCU4R8NelE3//a8/4rcHoJwQ82SDNky9nfDm0vuQApQc8bcZiEK2Bkb3kxaBsbQIlTfOT72PAZyTTotsYAsxaZGUce1oVl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761101; c=relaxed/simple;
	bh=OgAhawLj2LuPuTBDhM8RVrn8M7VSu5vp+n2B/wMhiPA=;
	h=Message-ID:In-Reply-To:References:From:To:Subject:Date:
	 MIME-Version:Content-Type; b=PydQJc/mR0qVnnJ3KkQ9yGnJpl2latoC++8JNgBTF6Y88MVGwp3QtMWXge5qedT5Ua/KF+rcgJMUTJBrO8Yyew5ftL2NVMqTEUg7u5NytoMXYoLquTuNnDFtNN2o/MiZNgh3BAf/LB+WFn2mZy30xVan5f6QU/ZmHPrj4wEcCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com; spf=pass smtp.mailfrom=gosalescloserapp.com; dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b=WX10KA3l; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b="WX10KA3l"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-9773c6ea885so689612241.3
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2026 05:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gosalescloserapp.com; s=google; t=1785761099; x=1786365899; darn=vger.kernel.org;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OgAhawLj2LuPuTBDhM8RVrn8M7VSu5vp+n2B/wMhiPA=;
        b=WX10KA3lM7rm0eneVIn+YXhNnynzjEOjokYD6B6VH+qCiePc3YUC2Xu9oPBy85Z1ud
         BhZ+SdBpgQDHy7k6+PmK/umBoximF7WR+eYyooBRsucLq/9TM59Mi8KNywp7pWPa58wK
         pFHcGCVYe6xEVY3zbjhFS4JTMZWYZW3lSwB190pNhAyXyp5Vm8eIQZEEagPoX2Qw6wxz
         dcff/4/D7CkqtGKruSuVTKTdVi+cPfbDRO09E0II9rLnbLHC13OR/npiRuHucHzJtUE4
         5OlMvq+1aTrBhjuqWAqhcPvpeWQshDSDtesszofNd9Vz+rDFRz7vedEfiFLeaKBj8FTK
         bbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785761099; x=1786365899;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OgAhawLj2LuPuTBDhM8RVrn8M7VSu5vp+n2B/wMhiPA=;
        b=I4w2dP3K0Of/3LDdkL6ffpL2YhZgHIiDd7wOlwB23YXlFHyLABDAxq5vGx4fwHErqN
         96ULTIgeutwKvnP4hcNbVdKjupp9cYxg3QMv+X5qwi22+/bEZswzdbf8PAgThkmL8iUe
         XSx0id+2iJF61mjg3TJEO0uBeU6nuCf3hDExMg6KjEZVzLtR6m3hEPKOI41OSISWal7H
         +8hhKzAnHWHkLbYA/9ERHJ9VisZr2290+6HlWuCTEYRJWBgKb4cYQUBLZITLaA+Lg5D+
         zZzMzraSpO8N34b6KzOkgjlciKzqFdrifvWGdSaTfsqKcVq/wl4OyzgaByXlUwwID9yu
         zdew==
X-Gm-Message-State: AOJu0Yw6GpjwDkQHqdcvyu9WWC5qX615C5B3/FMwdsAAqjtfS1RPIiLv
	exuqnjR+lZa2GB6anK+a9hcwaMe7bR4YZ9rEMB41zjvPsmmPFCrHAU1X+j5PwtDy5IczEbnWaeU
	8aw8tPA==
X-Gm-Gg: AR+sD10Ld52avP6M3oDN6Fs267s4s+WARe7qU5yqU3pRBQ6Vy+uVOvtAPDh2iZXWKJm
	zIXi9BAd4XDWul8PMPV2xPa+uQU60O/jQuVNB5bJSPyElDEXgZNN7YbGGRxeDB50CoKsNbO2oUW
	E35N+REs5RczmSBLWKbFf+CY+dseRrFiM/7Q76UX1HCtcPBNdjn4go2np1AxbCD/RF9ltxYnQqV
	TEDeTsSytwyHhjJfZGf08654CuvIhIho7nGulx8qfOh3pLsHg+hAy5sf/Q42hidexmR8jn1qcfa
	jQtRVvKBBjxj9g/IQ3mmdjraiHdsaDQbLmSiZhn54JdoxJbLMq9Y6r0IMjwg7quaadH325owJaJ
	MKD+XJqZZuVDLUaxl8MN7ezFbN9GJ1XKo/PM+dG8SLFreUJvW9gAUxnqev/um7mwLdhTJh16LGe
	JvYGbNefyyY3SsH/ZMdmbrAZyADC24vVKv6uI2b71/aYgRnG8rM0L72Q18gzktg/1c5qXbj/qDu
	/Sv6q4zAaZzp+dfdeDe5nL1fZoFcm0RLE2JAAf1+CLVtHi51tq6gk15HVJZcmQj1gX77msvccqe
	caMVL0WyXQfQDHRCLgl7iN7pAAc=
X-Received: by 2002:a05:6102:2d0c:b0:6f0:3ba3:7d84 with SMTP id ada2fe7eead31-75b21f63c05mr6840887137.5.1785761099168;
        Mon, 03 Aug 2026 05:44:59 -0700 (PDT)
Received: from 019fc7a7-ea1a-7347-a6d9-af68e1cf2ec3.local (ec2-54-163-66-194.compute-1.amazonaws.com. [54.163.66.194])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-759c955c3ecsm5929991137.12.2026.08.03.05.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 05:44:58 -0700 (PDT)
Message-ID: <019fc7a7-ea1a-7347-a6d9-af68e1cf2ec3@gosalescloserapp.com>
In-Reply-To: <019fb7fe-45e4-74f8-8902-d177df85f972@gosalescloserapp.com>
References: <019fb7fe-45e4-74f8-8902-d177df85f972@gosalescloserapp.com>
X-Mail-Abuse-Inquiries:
 https://app.instantly.ai/privacy/report-abuse/019fc7a7-ea1a-7347-a6d9-af68e1cf2ec3
From: Emily Cooper <emilycooper@gosalescloserapp.com>
To: linux-crypto@vger.kernel.org
Subject: Re: Yale Blockchain Initiative sales
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 12:44:58 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi,

Wanted to close the loop on my earlier note.

Is it worth a short talk=
 to see if this AI tool could lighten your client workload?
=C2=A0

On Fri, July 31, 2026 11:45 AM, Emily Cooper <emilycooper@gosalescloserapp.=
com>
[emilycooper@gosalescloserapp.com]> wrote:

> Hi,
>=20
> Still curious if managing client calls during volatile markets is a =
challenge for you.
>=20
> Happy to share a quick example of how fintech =
teams solved this.
>=20
> On Tue, July 28, 2026 11:38 AM, Emily Cooper =
<emilycooper@gosalescloserapp.com>
> [emilycooper@gosalescloserapp.com]> =
wrote:
>=20
> > Hi,
> >=20
> > I know schedules get packed fast.
> >=20
> > Would a short call this week make sense to explore how others in crypto=
 use AI for smoother client handling?
> >=20
> > On Sat, July 25, 2026 =
12:13 AM, Emily Cooper <emilycooper@gosalescloserapp.com>
> > [emilycooper@gosalescloserapp.com]> wrote:
> >=20
> > > Hi,
> > >=20
> > > Just checking if you had a chance to think about the AI platform I =
mentioned.
> > >=20
> > > Would you be open to a quick chat to see if it =
fits your setup?
> > >=20
> > > On Thu, July 23, 2026 12:04 AM, Emily =
Cooper <emilycooper@gosalescloserapp.com>
> > > [emilycooper@gosalesclosera=
pp.com]> wrote:
> > >=20
> > > > Hi,
> > > >=20
> > > > I noticed how the =
volatility of Bitcoin=E2=80=99s price can make it tough to stay on top of =
client communications and leads in the crypto space.
> > > >=20
> > > > An AI-driven platform can help manage calls and meetings smoothly =
without stretching your current resources.
> > > >=20
> > > > One of our users in fintech found it easier to keep prospects =
engaged and schedule appointments even during market swings.
> > > >=20
> > > > Would you be open to exploring how this kind of support could fit =
into your workflow?
> > > >=20
> > > >=20
> > > > Best
> > > > -Emily
> > > >=20
> > > > P.S: let me know if irrelevant.
> > > >
