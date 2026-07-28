Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968CE3A7F48
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 11:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785238709; cv=none; b=pCHQJtbpX4AhVVw8bcNoqFH7a2jKMj8qA+mr7fF5JaFas0kUsw/VVdHpVydsMyiXFgk9AxcDXkO3Y/eq1bE5OG8TbuKkPVRBvjfAM6oOQj9ETEqrcm+SjfS/49E/bkIH3GJvYIQvLbK/lVNJsfTO9RJYp7DBAfp2MdWQtZKZBNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785238709; c=relaxed/simple;
	bh=6u1EhkWAIP1mrAPpodYvc1kednT6gyhnsXvZeaz1/ec=;
	h=Message-ID:In-Reply-To:References:From:To:Subject:Date:
	 MIME-Version:Content-Type; b=RSmcQvxYNQmtTveHTMx5lpHohgWqfVKmfDq+Oc5TTi7o+ZwU6x4RHqeyGsKTyj6Y8sIuqRyd8sYwgzaiWGkf9tcpabdWPEv2BbAEFjE17bYAHupmz13Yw7MIlEbjvWduoBeJGdeZIRWBkFu5W76i17q1GWQ20ZIZnpc4bW2JakA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com; spf=pass smtp.mailfrom=gosalescloserapp.com; dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b=MPt1VBZR; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b="MPt1VBZR"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9309d4ea213so310432285a.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gosalescloserapp.com; s=google; t=1785238706; x=1785843506; darn=vger.kernel.org;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6u1EhkWAIP1mrAPpodYvc1kednT6gyhnsXvZeaz1/ec=;
        b=MPt1VBZRM8D1dIYtlvIjJBdFCsmDOolV0+XhdLYhWuISpYiLCmIqjn2bowM6Dr+vJt
         wZamXTf9oP7ndOuZ7/604x1UHGvotj+tmtfaLmtgZyzEiW7CCGakqU/UynuLwGnrdede
         lsnn4k3oj3xtvHW+VOozSIpzW+6O9ASph1X3GDn1pGq7Bt8j/WLkWgGfuTf55ct+1+S5
         5tkEYpHOI3jPn+bzPMBP9R3JPH0HGkUSgf6dCH574cOND1AaNIxXpqhawXhEy4MhvZ1h
         +KZriu4q3tIex9S76xkVWk7rJIzdNqGKT/2FUrvvylOpa1ZTk3gotzoGU/77eBkWpfuy
         cW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785238706; x=1785843506;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6u1EhkWAIP1mrAPpodYvc1kednT6gyhnsXvZeaz1/ec=;
        b=c61bhMv0jQyd8EfeVFHomCZdtJU/rv1yz13w2SoJvBi0q+tPLruyYKJXPnZloKQThc
         kVMJo02g85vZQy1OWjp3YqxsH3e/1ORGg1vnia4Fpt4vkB9X8cQT4fTt/d9iSAO8ZVbH
         eUoWeajI2/GRNGdyomSDdR1TsBkkjW7k319wlA1tPFehTbYTC0IX7hA3bzJtKJEOCnzF
         t+fWhIi2zqphmhrOb83wlAjwxh8aKxTmUP7jcASP8YZciA9wdJH2AwqVKeqgPL5Bookk
         naV/wA5YZx/FqyaemK6By/U1n2jnpAiMd0QlB6QGsvKtauKu9ccBbR2s1vhD5SN3OtnT
         I5gQ==
X-Gm-Message-State: AOJu0Yx7w53xSafwuFSfmEhpUoovl7RLAhkL9r9EjU9IWzN+B60lSwVS
	iF57wNwgNiQZlUHWdUVNukR3o1MW4UwCc8b1BlOvHQ579ZtDE4/JCf86vYbuvJE1gUTCQ13Qw+N
	On7tZ9Q==
X-Gm-Gg: AR+sD13nOqYTN38TR8Yj1x9RcOxGEhWvmE9FnN6aOUeTzDBmEqDOAsZ+Eavmew+sbp9
	4VYkpkj3kUOTR+PoMtXTSoDonGc5NiipnOZGcGrPzPdfQlOtqXC3aq7AYw9Riw6pPBDohM3konl
	WZ1EvYPk2yLmT9Lh1sCmxLBp9Fqd2eqY73DDtF72akEPy4teIvbDsOFV/SHP1pTBBBq9IopTS/H
	CAoiK8KGNi17GkaXe+evWZfM+VNhJFnO4rpcfiDU8y6Ng/8cqNPPzVvPGIUWtPY5/bU/pDX+rSR
	lyW0giTxSrDi9J53tL7wzaBPY27FXMdudXgA+fPnydEvI41vprkp/Is1duZ7ezivNRwgSb54aQI
	2Blblm4BnWmhsvDZjIa6+ry9elYlnU/b0yDneVscUnOP19VcpVc6Zt+oZ4eunq2rBeAgswUaQkf
	/8Ketk+kIHPXS0MSODK5TBc36ODGyY1ET9fuD3CIG5lw8AWSO/a7QngPmUTTUlArm+yDp7wUWZY
	f8vYpjjT4083yVZNeaOMkAyYbhYvX2vwfGqIOtR4MgSAxNxqw==
X-Received: by 2002:a05:620a:1a08:b0:92e:5554:a80e with SMTP id af79cd13be357-933026c3142mr160235685a.39.1785238706440;
        Tue, 28 Jul 2026 04:38:26 -0700 (PDT)
Received: from 019fa884-d5bc-7b61-a635-8158a97459d5.local (ec2-3-239-41-67.compute-1.amazonaws.com. [3.239.41.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de6523c4sm823574085a.34.2026.07.28.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 04:38:25 -0700 (PDT)
Message-ID: <019fa884-d5bc-7b61-a635-8158a97459d5@gosalescloserapp.com>
In-Reply-To: <019f969e-effd-7c69-8b5d-8c53c3926c48@gosalescloserapp.com>
References: <019f969e-effd-7c69-8b5d-8c53c3926c48@gosalescloserapp.com>
X-Mail-Abuse-Inquiries:
 https://app.instantly.ai/privacy/report-abuse/019fa884-d5bc-7b61-a635-8158a97459d5
From: Emily Cooper <emilycooper@gosalescloserapp.com>
To: linux-crypto@vger.kernel.org
Subject: Re: Yale Blockchain Initiative sales
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 11:38:25 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi,

I know schedules get packed fast.

Would a short call this week make =
sense to explore how others in crypto use AI for smoother client handling?
=C2=A0

On Sat, July 25, 2026 12:13 AM, Emily Cooper =
<emilycooper@gosalescloserapp.com>
[emilycooper@gosalescloserapp.com]> =
wrote:

> Hi,
>=20
> Just checking if you had a chance to think about the =
AI platform I mentioned.
>=20
> Would you be open to a quick chat to see if=
 it fits your setup?
>=20
> On Thu, July 23, 2026 12:04 AM, Emily Cooper =
<emilycooper@gosalescloserapp.com>
> [emilycooper@gosalescloserapp.com]> =
wrote:
>=20
> > Hi,
> >=20
> > I noticed how the volatility of =
Bitcoin=E2=80=99s price can make it tough to stay on top of client =
communications and leads in the crypto space.
> >=20
> > An AI-driven platform can help manage calls and meetings smoothly =
without stretching your current resources.
> >=20
> > One of our users in =
fintech found it easier to keep prospects engaged and schedule appointments=
 even during market swings.
> >=20
> > Would you be open to exploring how =
this kind of support could fit into your workflow?
> >=20
> >=20
> > Best
> > -Emily
> >=20
> > P.S: let me know if irrelevant.
> >
