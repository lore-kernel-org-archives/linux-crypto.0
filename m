Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6BA33C502
	for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762970246; cv=none; b=X9cuytQaaEQ8cYl5lY3cWiFiAJ8CVYZCbOFFdZh2/IMOKvnpWtrzSG+vtHbRKQYaUW4z9ImXA9cX/d3394nut4ZUbspKZjqmrR8C7XA9sPVGx/DuBLejnaeGFKg3DSMARFpHa6JMdd6yulwkSZW63lAon8xueBDxofaTCBuAqEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762970246; c=relaxed/simple;
	bh=MjEDmAYq4++Uq2lZMtscjOWc1UU/sEDwm5bxzdQwgKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mz6ENxwbisWHMtN68DKmPEwcg3ke4AnI5pCqTnBmpd9w1Jo5s/QiXsuvixAo6orTCs12UY+0JuyWfg0IZ3AREFDqSZLA5dBID9LuxyvkkK6h/IspMNFNMN7dg7KcD5l/uWWaWJwhSVYXu4Ac2k3YF2QLpKT1TdKVXvB8LIxFhAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GJ09pnOY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GJ09pnOY"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-594516d941cso1253318e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 09:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762970242; x=1763575042; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ewolTBS7IZhPq/yo/5TbBzsZlBs135aryiIEkWYvqI=;
        b=GJ09pnOYIIUi8zUlB+/LmdkFnoXWCl2PymtZ7bxN961n/YsXyNFy8fvViIuHHGP5n1
         HvWzISfzdTE32b2lXT9ubVFGgp4E9lc66kJKvQzs0byf9v6Sn7qe58YvCNKfH1lKSMG+
         E2OGWKt/dtTE8Ja9q4KJXpZY0neVu09QC6yooF+5o2etjk9zINuhh6XZm5FKwPDBwaXH
         AwGKj2sl4YRK7qCAxCKqMplfFuC/m5swIWIBzs5CDNEYrcOpYFN5/Fe/UR3wBSxkZhc7
         P/f4r69I49E3zIBW8+Ahje+FQCrawYpuy7VMWeGgXQUjiGkfu8KZ9unlCnw424CBhmWv
         t93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762970242; x=1763575042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ewolTBS7IZhPq/yo/5TbBzsZlBs135aryiIEkWYvqI=;
        b=nMej11qxRpVUE2mzY7N5JGJQ8G3SQT4h9ilaVGpcSzddpntNSidBBODPuwfN1KaaPz
         F2POeSJaFZPm4r094w+xXaGXbxzkcg2+aYS0yuybzDk0il6VPlIBliGmbpvTNAH8+8lp
         l9Kbs5t15OHuu3tFVENPfW+YUM4OEZnxnZ988W0kvgsF1YXbvslduJJG5HUxwrNCuU1N
         QiyGfmHKgakpaIXLASnhm700qflP0SrJW40FZKmcH+kvai/C9qqLXvPaak+ZO9bgaNH4
         dDx77mUSt08RG1F4Dy2CsQXk0joQsUl5SAHXHJEEQnuJYbikVe2jVlFhBLGZUJJ/Cepg
         fqVg==
X-Forwarded-Encrypted: i=1; AJvYcCUCW6/77+MLtuo6s0+9TG2mcvCBlDvwaJGUSI43ODouMEyaGnXzjsvVk9j7ax2BRKQSmiHh0wZ8GEkb8Fo=@vger.kernel.org
X-Gm-Message-State: AOJu0YynkOyCoLTWZNv6BHjyoaTjCtlnhhWnBkcavwzRXEHpl3hnfK2/
	yVAhutsGs4JlNloIhaukJATNeN7XyHtQ2vV6MFNZDm8lEC1V7KI7qq3o1+i+suyjbZO5p44pATf
	S68YdnGQu9KSI7qw4ondXUyfDXhgi8CVgcAa2wqeGyA==
X-Gm-Gg: ASbGnctqyLmUgyAH++sPhzj1ys9s09h++nGOBGhG68CirDFzRimjuDpKIZtL7JggC/h
	qVErLmXhYeuSWrDePMrAZ+wT9k1xsl/M7TVHL7zGaLxmyXChSmCYXvK0Apair/2y8tbaUIcDW7Y
	KgWkgElfSk+ALsyrTDiMMzKb6336Ebfoi2OKS8U33S2KPYX7daMwhyMGIPtdczIqLlvP/vRS1yG
	N9z6ZklOW7x8Xgkw8Ji0SETiViM9K7zSIlbl4U1u5bMYypVpek+ssulnhlWB/mZkSwRMoE06+Td
	LfeWFaYuXK+XoYJa0A==
X-Google-Smtp-Source: AGHT+IEmeeVaV5q744epyzVmrwDVFW7j4/cmgThHS6LnRlZKUqyjMPJJRdHK4mRn9u1u/f1P1HM1MIsX1SPUfQ8SiIU=
X-Received: by 2002:a05:6512:2388:b0:594:2d02:85b3 with SMTP id
 2adb3069b0e04-59576e02c4cmr1410016e87.8.1762970241801; Wed, 12 Nov 2025
 09:57:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107112354.144707-1-marco.crivellari@suse.com> <aRS9Vk6yh1wEq614@gcabiddu-mobl.ger.corp.intel.com>
In-Reply-To: <aRS9Vk6yh1wEq614@gcabiddu-mobl.ger.corp.intel.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Wed, 12 Nov 2025 18:57:10 +0100
X-Gm-Features: AWmQ_bl8otP7iEdFT2es07jTQBY0O2yc5dPncwp_ZOFehTsDj7eU4vYdCQlrMH4
Message-ID: <CAAofZF4UJ1UGAH=r4cWn5HssTinY5e=aXRRMj95Bz40deakmjQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - add WQ_PERCPU to alloc_workqueue users
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	qat-linux@intel.com, Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2025 at 6:02=E2=80=AFPM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> Hi Marco,
>
> On Fri, Nov 07, 2025 at 12:23:54PM +0100, Marco Crivellari wrote:
> > Currently if a user enqueues a work item using schedule_delayed_work() =
the
> > used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> > WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies t=
o
> > schedule_work() that is using system_wq and queue_work(), that makes us=
e
> > again of WORK_CPU_UNBOUND.
> > This lack of consistency cannot be addressed without refactoring the AP=
I.
> The reference to WORK_CPU_UNBOUND in this paragraph got me a bit
> confused :-). As I understand it, if a workqueue is allocated with defaul=
t
> parameters (i.e., no flags), it is per-CPU, so using queue_work() or
> queue_delayed_work() on such a queue would behave similarly to
> schedule_work() or schedule_delayed_work() in terms of CPU affinity.
>
> Is the `lack of consistency` you are referring in this paragraph about
> developer expectations?  IOW developers might assume they're getting
> unbound behavior?

Hi Giovanni,

Sorry for the confusion. The first paragraph is mostly to give some informa=
tion
about the reason for the change.

It is correct what you are saying, indeed.
I will share the cover letter (for subsystem that needs one):

----
Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an
isolated CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.
----

You can find more information and details at (also the reasons about the WQ
API change):

https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/

In short anyhow: that paragraph is not directly related to the changes
introduced here.
Here we only added explicitly WQ_PERCPU if WQ_UNBOUND is not present.

Thanks!

--

Marco Crivellari

L3 Support Engineer, Technology & Product
