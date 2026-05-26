Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380964315A
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801814; cv=none; b=FO8vnVMySQGJltNOlsk3Y0smZRshqAkYw+k2bTNxozjQD/V2W8pPj27gYrPb2H/z0SQl0FTGesvJ1hZog+z5V1rcgg/5Hf40jiNw6yG3LA8wMRJ1FY0L34axjqVSLP4c84So6jS/15K6qpjV6PMVFbh1Zg09Y4HpjzgL4HXXf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801814; c=relaxed/simple;
	bh=gCfswUgGOoy46ti3xo1eu8Ugo/7hokJi7BX3VtOeQWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGauwIv11T2QPlH10ZkPXXpb03Q2S+VR0UirNaKZfNwbuJ8P3oMGSq5nl3Qsr7+57tAtA92aK5c3D9RRzoHxX8EzJBgAG++T0MZ44xS1j464LYpuPsA7ukjx9DKNpnSRGPvI6QZUWnXUiBlgEeK2/d3i4CwraHJjBjKNg5AJzHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=THHFZjPa; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="THHFZjPa"
Date: Tue, 26 May 2026 15:23:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779801810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dA1O+oAgkTJZXV4+UuR5kAXFpZlcMZyWQGu/ArL/mPc=;
	b=THHFZjPa+PNUTkzfwtnycYqtnqa/Q+TcFiLXqacr1iXLTst404xjB04Of8sKarPnbJuYjL
	cno4WnHNtID9GBkIjyUNSstJve1dXErAwiWcOVx+OJkkmBEX2YrHGh9tth1c5HX00sCAFL
	Cj27oNarGKQ8YhYyza28odI5pc2rhKk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sock: add sock_kzalloc helper
Message-ID: <ahWezce_kddgrgy6@linux.dev>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
 <ahBRCxCXbCq5LeCc@linux.dev>
 <ahVkZOxZtFes6Huf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahVkZOxZtFes6Huf@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Tue, May 26, 2026 at 05:14:12PM +0800, Herbert Xu wrote:
> On Fri, May 22, 2026 at 02:50:19PM +0200, Thorsten Blum wrote:
> > Hi Herbert,
> > 
> > On Mon, Apr 27, 2026 at 12:41:30PM +0200, Thorsten Blum wrote:
> > > Add sock_kzalloc() helper - the sock equivalent to kzalloc().
> > > 
> > > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > > ---
> > >  include/net/sock.h | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index dccd3738c368..20bf406dff2d 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -1904,6 +1904,11 @@ void sock_kfree_s(struct sock *sk, void *mem, int size);
> > >  void sock_kzfree_s(struct sock *sk, void *mem, int size);
> > >  void sk_send_sigurg(struct sock *sk);
> > >  
> > > +static inline void *sock_kzalloc(struct sock *sk, int size, gfp_t priority)
> > > +{
> > > +	return sock_kmalloc(sk, size, priority | __GFP_ZERO);
> > > +}
> > > +
> > >  static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
> > >  {
> > >  	if (sk->sk_socket)
> > 
> > Can you take this series or should I resend this to net-next?
> 
> This patch needs an ack from the netdev maintainers.

Jakub, netdev folks,

Could you take a look at this small include/net/sock.h addition and
provide an Acked-by: tag if you're okay with it going through Herbert's
crypto tree?

The series has Reviewed-by: tags from Kuniyuki, but it hadn't been Cc'ed
to netdev before.

Thanks,
Thorsten
