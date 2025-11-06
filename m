Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2080729898B;
	Thu,  6 Nov 2025 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762421344; cv=none; b=dc2TZqafcf+Sk8Aa+98A/MT1HjftypRr7lGYPJMT15FoS4IQcBKTfPzCzIx8wpXnxO5MWTKU0vUnkSVOqZm6cM8ESLKBdhSoVrPCVtS/z/fJU+JAMYCbFiJnpio7Q+PU9o31cJ73oaOvV4lDObeFL5v6OeQDkL9D/ADX3xSREO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762421344; c=relaxed/simple;
	bh=dGESzB/CV+7hkRnVezqLsXuXTaaTagrPtaeu2/xicPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFQYgntOXQJxbuUHx40gv8OJ7TnR7qfN6auiz6sJmGa4+oqEgNqME4joXGf46u/8zvewbkT9XGsofO6Nh3H0Ox+xXNnHkxlf1KXblMQlUdRuSeLpwqTlTxitgji//4oZFMg+3XaxEdenrQPGtCbbahadQQULQwsdTNWP71Pgbnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gjKqUnj8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gjKqUnj8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=c4IFy0j3APf8RvRvtgravzWgcn5rLG9kiZv9V2rYBBQ=; 
	b=gjKqUnj8eeniNM9WApQ8skgPnEe4Qup5uy2IKMzHM3cX4UMHGGAOAh7s8guJOsCL3EQsrdP89bX
	0T/QmjJiiMk9jkdFaSsG0zhSzSyZzKwPoJXF4S1H076tCrjD/Fzwfekcl1qsys4J7iecBUxcOQ2UC
	Qw6fYsMcrnIH3BNA/+Ai6z7cfqvm1aP92WWRMGgiJGw0fuqzyPwKJJUMSxUbsyheFh6x5f4wRj3H7
	+FGqRkIu0jdyelvxcjufThbGRyiRE6J9DNH1j/98FbxO4mc8pBBzpHfBi4zwxmId/JJ409NsYSdZd
	bWjkM5AtKto4gaPvq9omRNRVAEuWP/h3F5Ow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGwIQ-000tGB-34;
	Thu, 06 Nov 2025 17:28:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 17:28:46 +0800
Date: Thu, 6 Nov 2025 17:28:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>,
	daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
Subject: Re: padata: Is padata_find_next() thread-safe?
Message-ID: <aQxqTiUUrDmF5M_X@gondor.apana.org.au>
References: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
 <68c34150.050a0220.3c6139.0045.GAE@google.com>
 <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>

On Tue, Nov 04, 2025 at 08:44:53PM +0900, Tetsuo Handa wrote:
> syzbot is reporting possibility of recursive locking at
> https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b .
> If this is a false positive report, the fix will be as simple as

Yes it's a false positive as reorder->lock is never the same as
squeue->serial.lock.

However, they both have the same data type which is why lockdep
is confused.

Please provide a patch that sets the class for one of them to
something different.  For example, change the lockdep class for
reorder->lock using lockdep_set_class and the problem should go
away.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
