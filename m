Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A523D37882A;
	Fri, 17 Jul 2026 07:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273917; cv=none; b=Tt9K66Tsr28l2CFV97Bf+04Ti/Sa4NsHB73GhGY69PtCuYTMHdXE9QXM6OEEVvKCtEM9JkXg879r19fkGy6eypb7XZHm6aI/ixILQsrBoF7ROn5rMFAkYJ3ORy6yK/8t4OSGZBOZBfbvC/na7f8/6TnQzvgJfq3rYqzwHEGq/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273917; c=relaxed/simple;
	bh=35Egi6eYojtwSuFv2vZqQOmZXxTNspHF/kyNeaQV+6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUcWj1AG+JPypRhck209B6RQu6eyIDoXtZ+fqBpdKgCZi7Z2G1g42yxbJ1AvVKtJh/xCQeuQB6NkF6A8BfZUb6gJapGY/LUzF8syl0I2qsMFlX1FRSjEOBAIVu5qm5lPhD4tI/er4XaxEglePtRwPbCJRpmJaASUjIrHGgbpxxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsqBt1iy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsqBt1iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDFC1F000E9;
	Fri, 17 Jul 2026 07:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784273913;
	bh=3bTr/9a59bs+l9+c0stRNq6g+HWb2iB6xnFMyoYzLsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZsqBt1iyWGyZOFpeRsX5JxBs4Dh7Hq2nc7xbmdCUUlhPcG3mLSwdM6ZVU1A+pmNyz
	 MykGQ6NKQJaNE3NdrCwOfPQlCur6ZZhs3roEwfE/zM72GBO0cxcRZe+DdtNFaMDWsD
	 C6fnFHvLkqLwKFA4/G+WxYzAxiRRm0cSinvXzuQ0=
Date: Fri, 17 Jul 2026 09:38:26 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: herbert@gondor.apana.org.au, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: xilinx-trng - Remove crypto_rng
 interface" failed to apply to 7.1-stable tree
Message-ID: <2026071718-agreeably-sapling-e9b4@gregkh>
References: <2026071501-handstand-curtain-592d@gregkh>
 <20260717021831.GA1847@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717021831.GA1847@sol>

On Thu, Jul 16, 2026 at 07:18:31PM -0700, Eric Biggers wrote:
> On Wed, Jul 15, 2026 at 12:16:01PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 7.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > To reproduce the conflict and resubmit, you may use the following commands:
> > 
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-7.1.y
> > git checkout FETCH_HEAD
> > git cherry-pick -x 32b4d29280ed2a991dc196d5845b892acedc63b8
> > # <resolve conflicts, build, test, etc.>
> > git commit -s
> > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026071501-handstand-curtain-592d@gregkh' --subject-prefix 'PATCH 7.1.y' 'HEAD^..'
> > 
> > Possible dependencies:
> 
> It actually cherry-picks cleanly.

Odd, I got this error:
Hunk #2 FAILED at 13.

> And you also failed to Cc the subsystem mailing list.

We don't do that for stable FAILED emails, as that would just spam too
many lists too often.

thanks for the backports!

greg k-h
