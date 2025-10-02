Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820F2FBE01
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 10:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759399377; cv=none; b=CpILSUKc3Fd1T6KsVdwzNMdHvH/IUV96HcP6SRm2E8zwCufOs+FZLYc+vwOFvQKIAEZ1oMsSGn6XoBw9J0UcDJGbNh/T39qJLgPKV+/k4kcP24RSlekzFuCO2WdINdgxUlr3QKCdLx7y2l8Le/Rlos9HHqiGpkHUASV6bzwis2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759399377; c=relaxed/simple;
	bh=oKOvZbmQNCWQ//hSnLqE+hNmE/wFXuNJObFRI25KdQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVNC/0d2T7dIUS1GMu5W1oofdbX6HFmlfqoXFzb3jSW+dWRcJPizjpMPizd1lrCDwJ5YwHSaFpi87rbBB/ySK4cEV3ZdPZQPjIut0hLYSsl7zKOlxho5ZqfPQePDrJbf98Px7TUOwNpuaZja8cFp00myvmwCeXYlb+RkC0QEnr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b07e3a77b72so387445866b.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Oct 2025 03:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759399374; x=1760004174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJ3f0Y8jx/ORdUpe8rUwDsc+LhxkZNLDRVr6mrw2tpc=;
        b=tvlzjo/15K38Ed9tt+DHuuISv5h8d98gLkws9FPp3uatVGlWXGV+RS9PmFYTQciXHU
         Jv7arGTVs+vxpuge5U6fmT+SOoXkdqWeRn6y8H3ZqrTXsuvQM3dNuen/ecaROloeDPr8
         P6bCEN1LukOH+hQee6NYHY4JzEMfVwyPmCFWCmCmxkOyziO5ZZUAQ0GQZm3CmcBbHJPH
         u/ldyOdHx48xolK2U+6fq9GDqwNiEwjjfjI/07M0dV1N924XkM5lvx5I65AISj5jaPQs
         58CIYkBTv1kprf80gu64VEr2AtbCngY8w/bDpRd+tJwsiliwKGucEafaUdqybDV7J+MS
         Sg5w==
X-Forwarded-Encrypted: i=1; AJvYcCWGRUg9CBojOTAfHSueEiJ/bKSl+EJ7c2Gb4S6Er9SSlJXjJHG5eK1UHSWZbINtb9LLhpBA1b/JpcU02Kg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVM3Q1O+Z1pzshqfz2PB1uLrNqqTSGDM0pSj2hnGt5TQY7dk6e
	xY/l5TSCM5u3kZrsYuWxOTf5aJnRMz3/tjY3Ihe8lSwDvBoHvY1u2J+s
X-Gm-Gg: ASbGncvIHaTVPd0ETwBs/vYLog6H6wpe9JsqaXfzvb6vTplKvnETWQqzdNR+/TVihGK
	Eqw5wVzub/ezqYGeftfyx4TrpDfry4rk5dklzNkmh151lC+Mtj5iHUzh6M4l7/D2v+me+TnIg/X
	PszeQGI+Mzc+Th0inGKlYU15VeQOer6HFeGwVRuG/LrwDZuyQM3QHwmlmOcN/mIivSLeU5fxWa/
	MA5BCJGwnOQ603vmvKCYD1pnCl+y6UP2Mc7B/2e5yFBJm6LH+k6bvnd9b1svrUdtBb0qSJQepkG
	WOioZpU96CwFSwMuzkSfIkUwMPqsv3EciREoeqkrAFF5kKbnpwJnO5+i72pwKXpCLTEkBVCx4Bh
	JqSPRy1L3OagvXJMNPftF7n6mm9Bxxmu03tZL
X-Google-Smtp-Source: AGHT+IECt7u/9qQGkVz0M8l72m7XI4NHOj3MUzKdcpcelojvKIeJ3ZA1Crkq5c7f9e4R+Lj32nMt7Q==
X-Received: by 2002:a17:907:3c91:b0:b3d:e757:8c3f with SMTP id a640c23a62f3a-b485becf38dmr356982266b.30.1759399373350;
        Thu, 02 Oct 2025 03:02:53 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:5::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865a83482sm177255966b.26.2025.10.02.03.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 03:02:52 -0700 (PDT)
Date: Thu, 2 Oct 2025 03:02:50 -0700
From: Breno Leitao <leitao@debian.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Michael van der Westhuizen <rmikey@meta.com>, 
	Tobias Fleig <tfleig@meta.com>
Subject: Re: [PATCH] stable: crypto: sha256 - fix crash at kexec
Message-ID: <vz7xsyrtgg7ss3jlxfykk7frjiwm32nu72pc7pfi244g3ssm77@k7i7t7c3o4lx>
References: <20251001-stable_crash-v1-1-3071c0bd795e@debian.org>
 <20251001162305.GE1592@sol>
 <jm3bk53sqkqv6eg7rekzhn6bgld5byhkmksdjyxmrkifku2dmc@w7xnklqsrpee>
 <20251001165455.GF1592@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001165455.GF1592@sol>

Hello Eric,

On Wed, Oct 01, 2025 at 09:54:55AM -0700, Eric Biggers wrote:
> On Wed, Oct 01, 2025 at 09:45:07AM -0700, Breno Leitao wrote:
> > Hello Eric,
> > 
> > On Wed, Oct 01, 2025 at 09:23:05AM -0700, Eric Biggers wrote:
> > 
> > > This looks fine, but technically 'unsigned int' would be more
> > > appropriate here, given the context.  If we look at the whole function
> > > in 6.12, we can see that it took an 'unsigned int' length:
> > 
> > Ack. Do you want me to send a v2 with `unsigned int` instead?
> > 
> 
> Sure.  Could you also make it clear which kernel version(s) you are
> expecting the patch to be applied to?  Is it everything 5.4 through
> 6.15?  It looks like this bug actually got exposed by f4da7afe07523f
> ("kexec_file: increase maximum file size to 4G") in 6.0.

Good point. I've put my wanna-be-hacker hat and try to crash the host
before commit f4da7afe07523f ("kexec_file: increase maximum file size to
4G"), but no luck at all.

So, I would say we want to limit the backport from v6.0 to 6.16. In
this case, it seems the easiest thing for stable maintainers is to
"Fixes: f4da7afe07523f ("kexec_file: increase maximum file size to
4G")", which will limit the backport into only affected kernels.

Let me send a v2 and we can catch-up there.

Thanks for finding f4da7afe07523f!
--breno
