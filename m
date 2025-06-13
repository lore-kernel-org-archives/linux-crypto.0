Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6437A1B95B;
	Fri, 13 Jun 2025 00:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749773799; cv=none; b=eZbBPtR20er4hB86xN7cLOn5TOOTMAi14wYg9jJIb8iZpXMK2+2z92ajPK8JvDAldcxai1QTyrhp4H36LMRmzCqgPQ/lt8rW5ZD9+xYZSqqUUhsp0UxKBfMwvXBh/Ugrt+arPtm6/DidoftE0oOUnTcyb9eYpRpnlxuM+wj1cCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749773799; c=relaxed/simple;
	bh=xlOcpHawrpAE7xy6gDyBeZgUCJfIzjIJTd8pKNa6LD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WtT0qBHpEYYyeRL26LyEhKNLmzsqWKD5q5ry+OXp6k4u2KfDB1x5eqeSAg6QI9dWf8tAY/JFigkGmsGuJFevXVTL7QzUYJiSLl/5L38+s5KRM+Mp5QzybMUVKj61prPdqkA2x0W4v6Dcqg2gTNM21jE3yLk7X0EX7ndaDG4jq/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LadC5D/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LadC5D/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DC6C4CEEB;
	Fri, 13 Jun 2025 00:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749773798;
	bh=xlOcpHawrpAE7xy6gDyBeZgUCJfIzjIJTd8pKNa6LD4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LadC5D/Cu+CFO0cDGK0falq7Nvk3BmGWe0T6kp1cb7ZjmzGLsDYEzGcc1zFCOjrp0
	 OP0XCVPPQv4gjTykEhmEuHf8mZgVz8XJHilaZdp1aI7K1EcDdHaF1vXxi+qnKFVd9O
	 r5Wf8uX88jxleyiedQdD6zSB+/njRo7NW/pAz2G2ZW0z+5F3JvKqOtGd9tF07fsPvi
	 FI84w44Hit28l2fAUQ7yga+7qt+hIbsNQ/AR+kCCGYb8KVYwkEpEj4/bO9TR7vpBlZ
	 ctqZByGMX9bwxKy9FIOBXi3sffRmw0z24FgTtMLzkG76JhUjX4T3bTtd6D+FVj/yTI
	 hh+PpZaJT1FBw==
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e812c817de0so1443958276.0;
        Thu, 12 Jun 2025 17:16:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUzkBbLYHKOGB2oI8U06t6ii3VxPUxS5NLW0wRu3Xo1ZGs42hKLiuZSGCpPkTwDKElLVjZ1avyvJwq/fBo=@vger.kernel.org, AJvYcCVDoGexyL5JE8w5baRzgyK5F47R12/wW/omlyuNf0qseQFzbK9Co/05r2yDgAu5PUPrj8akuhAGyengJGrPQP1bATAq8Ws9@vger.kernel.org
X-Gm-Message-State: AOJu0YyDxj/oK2sB1Grb7aVRkDa7/DN5HT+rC0QlqAfegkc1ryrXjz5O
	BPjNms+2ccKMZ99i9vAu4ZIaAJcfvLBa/eHfk66sVDoYtsfSYdhQSDxsrxhIk1mmCunEZ3ZU0XG
	qg6vQBestvV3YIlCJ7y1UZoFC19Xr/so=
X-Google-Smtp-Source: AGHT+IHvou+02vOs446nDMpw0JYSOHKq8Ing5XCWydC5vK4qd3PrqXqtVVEEDwlrsmUqBtQsumfoOxTRbKq0tOBjd20=
X-Received: by 2002:a05:690c:7309:b0:710:e966:bf96 with SMTP id
 00721157ae682-711637513cdmr21819607b3.27.1749773798185; Thu, 12 Jun 2025
 17:16:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514050546.155041-1-ebiggers@kernel.org> <CAKtyLkEnJGFCAuurSihU_bUTCzEqTXEx_0dG0OHQ8353do0okA@mail.gmail.com>
 <20250612190926.GD1283@sol>
In-Reply-To: <20250612190926.GD1283@sol>
From: Fan Wu <wufan@kernel.org>
Date: Thu, 12 Jun 2025 17:16:26 -0700
X-Gmail-Original-Message-ID: <CAKtyLkGayHWvW8s-CP6sx9Aj6SZ0MJXvTHq2UiiYnisaLzRqPw@mail.gmail.com>
X-Gm-Features: AX0GCFvDqOryf23shP1gLhA7dPmlh0oEWMar_VzX17VOXNn6aa6toU7g-xdtrxo
Message-ID: <CAKtyLkGayHWvW8s-CP6sx9Aj6SZ0MJXvTHq2UiiYnisaLzRqPw@mail.gmail.com>
Subject: Re: [PATCH] ipe: use SHA-256 library API instead of crypto_shash API
To: Eric Biggers <ebiggers@kernel.org>
Cc: Fan Wu <wufan@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 12:09=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Wed, May 14, 2025 at 12:40:45PM -0700, Fan Wu wrote:
> > On Tue, May 13, 2025 at 10:06=E2=80=AFPM Eric Biggers <ebiggers@kernel.=
org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > audit_policy() does not support any other algorithm, so the crypto_sh=
ash
> > > abstraction provides no value.  Just use the SHA-256 library API
> > > instead, which is much simpler and easier to use.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >
> > Thanks. Will pull this into ipe/next.
> >
> > -Fan
>
> Thanks!  I notice this isn't in v6.16-rc1.  When is the pull request plan=
ned?
>
> - Eric

The current plan is to send the pull request during the next merge window.

-Fan
