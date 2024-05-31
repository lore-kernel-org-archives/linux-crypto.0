Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599705695
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 05:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717132358; cv=none; b=EOajsh3smObnZ//srDufcdaxhpKxipyJEyBWgW/oYgXLUiyQunIzzyXbjkuWD4UJC9ac+cEfMCvxVyHUnYKRj/atRzHVRxiRa6Tv3Hs7kClXuDTErR7Ysj8Lm7yMpaTiJQXU+s0e4O3MKCIMJp47rGpHyJ53eRItvDmpOwFaLfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717132358; c=relaxed/simple;
	bh=TfOXduW5t+qL5w8UAIrl3irfTGjIkLgaC/4BuQz+4eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=juz8AN6NOL+7UQ1vfq3AlgYtzvMux+pBnmwcTNfuuwAnzWo4l9vxb6HmQhaA7lyxFsFD0AA7ARK/qSMU8G0yAAwOgNScOKTYUgQH0iVE2FJNwd4ilQpYipQabnX4g4966e9lnjnhvdRKZ59ZAOiRLrtxrJd3+TShoEOjLOy2CD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=QseXezB2; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QseXezB2"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-6c53fe7adfcso19521a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2024 22:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717132357; x=1717737157; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EITOv+XBU9sZw6MpWK9kMAOQKfHbGUGJ+ubEjkuDJJw=;
        b=QseXezB2rudKfDdOBomP3ejJLemB4WIox1npWCoh7PaSgDZFvKp7P2w1PcyeOMZ/KJ
         TAsJwJij0GVwy3D767teyyPoTsRly3wMzKLCKeaWgiqVCGkmXEjzH9KpB0XWq9wgVsWg
         dDyzVfFXlKLR+yWcLTLkm2yUJpy+TS6VACdwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717132357; x=1717737157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EITOv+XBU9sZw6MpWK9kMAOQKfHbGUGJ+ubEjkuDJJw=;
        b=MiA1LD7YYsc7h2L5xGu6eBPwiWKjC3CFDhMrweIRjURdxeWRM6hgrYS7eszejRZhdz
         PEDsR11t7Xgu3zwO49jPzsnCuB87Qn49ZyVOISuo9Vxf89EJi8dA+9iVxBw1EE0fjp2s
         8H7ZEzVR+eRKsRcdgl807KK2dej+OmtJ6uXNiWWp87Z8EzhiRWlSlIzE5+YXtcPq02HD
         dcOIFmeiuNMFzLiEnmifhr6dL40C01Nspcs2zIb7BP+ofteboazATVphCegT5erwBOQ6
         yn3v5bYGjZ0LqSEPww59sLpCM8/J5TbH0NIV0sKWd5rjE+FFIg4HIGcuwIcIZJPIkHfN
         aJoA==
X-Gm-Message-State: AOJu0Yy8Ac83R93Hr/n1SiHbDbTz9y4mk++nIYuZvBmgG6fjObxljQKf
	vbjrFSQpUZrtcKyZz3suiSDQDFFHr0f7F6eaBWbNzeHXddkBfu456orjgVB1nQ==
X-Google-Smtp-Source: AGHT+IHkqd+SRjgE5oQw/umXxt69Kh1T3yktBxDNI5LAxBNe3QXQofStu0vn5gQzsJO7w6f4UknDYw==
X-Received: by 2002:a05:6a20:5520:b0:1b2:184d:c197 with SMTP id adf61e73a8af0-1b26f2650c8mr898930637.42.1717132356642;
        Thu, 30 May 2024 22:12:36 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b7f3:e557:e6df:620b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323e9aa7sm6823525ad.192.2024.05.30.22.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 22:12:36 -0700 (PDT)
Date: Fri, 31 May 2024 14:12:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 0/3] crypto: acomp - Add interface to set parameters
Message-ID: <20240531051232.GC8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <ZllbHYL8FYlrCRC_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZllbHYL8FYlrCRC_@gondor.apana.org.au>

On (24/05/31 13:07), Herbert Xu wrote:
> On Mon, May 20, 2024 at 07:04:43PM +0800, Herbert Xu wrote:
> > This patch series adds an interface to set compression algorithm
> > parameters.  The third patch is only an example.  Each algorithm
> > could come up with its own distinct set of parameters and format
> > if necessary.
> > 
> > Herbert Xu (3):
> >   crypto: scomp - Add setparam interface
> >   crypto: acomp - Add setparam interface
> >   crypto: acomp - Add comp_params helpers
> > 
> >  crypto/acompress.c                  |  70 +++++++++++++++++--
> >  crypto/compress.h                   |   9 ++-
> >  crypto/scompress.c                  | 103 +++++++++++++++++++++++++++-
> >  include/crypto/acompress.h          |  41 ++++++++++-
> >  include/crypto/internal/acompress.h |   3 +
> >  include/crypto/internal/scompress.h |  37 ++++++++++
> >  6 files changed, 252 insertions(+), 11 deletions(-)
> > 
> > -- 
> > 2.39.2
> 
> So does this satsify your needs Sergey? I'm not going to apply this
> if you won't be using it.

Oh, I didn't see this series (not subscribed to linux-crypto).
Let me take a look.
