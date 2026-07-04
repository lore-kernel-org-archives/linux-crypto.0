Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92C218AE3;
	Sat,  4 Jul 2026 00:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783125640; cv=none; b=XwO7c6UEvtfX+j6F91EeckTGbVbM2tkRBo0reX8MZJHMR3MWSP7Pg7lW5VrXw1lIYXoZkRKu0mU7pWLeQPtyqx8aXLIEz7smfFPThvP/yYqCjHn3XUqC/+GY/fnaD7Qkwf7C6PvYkU91c0V/rtehY9VHbR3Q8LP7G0D8SgtYyh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783125640; c=relaxed/simple;
	bh=gBI3Zs4ek2eYMGiLZswJFa3WoIBsKoZAyHs/qlK83Kc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ir89IzvVeGXVdVV5unZmi/L5qqoomqMh0PUNLkLK3616RPib1CFroU36lwkbsHPxIEdxur4hDZ0tQwtrTNfkOfgld0M4LXIpT7N2vZDPeCxOUEMQvLPGi15CWpRY4HNe53LVZQdnAkP9pzVeX8GzRH85g/q6jlC+KcNakJE1ml8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D55dS1Nj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D55dS1Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DAA1F000E9;
	Sat,  4 Jul 2026 00:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783125638;
	bh=dK9o71yrpEUNlGSVfJCX9fcW6yA3yYMits5n7r1NLzE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D55dS1NjfGgE1Q3hi7Iwlqz7ZqJwmv/ins/CGf56Y5HA/p898N+Z9kse6xuyhjCoa
	 WLzVsydQbMieBNw7fZ51V2RurzWxLLMe6ObkX4wKluRwpnxTcaUQvz4adwcCdhxGZd
	 unLSKWbx2e3HKigrTOYyXB/lpMRVOiUL4ujZh2fg=
Date: Fri, 3 Jul 2026 17:40:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>
Cc: Mark Gross <markgross@kernel.org>, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>, linux-edac@vger.kernel.org, Borislav
 Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3] MAINTAINERS: Drop Mark Gross
Message-Id: <20260703174037.b0065a1700ccf814b8a5d760@linux-foundation.org>
In-Reply-To: <20260703173803.3589003-2-ukleinek@kernel.org>
References: <20260703173803.3589003-2-ukleinek@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri,  3 Jul 2026 19:38:03 +0200 Uwe Kleine-K=F6nig <ukleinek@kernel.org>=
 wrote:

> Sending mail to Mark's Intel address results in the intel mail
> server rejecting the mail. Dave Hansen confirmed he left Intel.
> The kernel.org address seems to work, but there was no reply from Mark
> on the discussion about broken email settings and his maintainer
> entries.
>=20
> So drop him from all maintainer entries.

These seem good grounds for altering MAINTAINERS.  It happens.


But

hp2:/usr/src/25> egrep "(Author|Acked|Reviewed).*Mark Gross" ../gitlog|wc -l
52

all gone poof?

Please send a v2 with the subject

	MAINTAINERS: move Mark Gross to CREDITS

Thanks.
