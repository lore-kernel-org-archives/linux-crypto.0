Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E9F84A2B;
	Wed, 26 Mar 2025 02:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742955382; cv=none; b=IUafFqhy6ETv8DwX2JrNTtL1rgXf5DkqmaiHL7Et2UtDDs2bT7enAOS0CRfY90s6xL7eLeBqxTwDhW6SnDYHqF7+cboqWZD1XIjt0LjM2t4f5UoDpsIjoE51W7o5NMcK8uSBFwFbyYugbnf9f7uyTwtKFk+Rx9R8V7G5V+/A5Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742955382; c=relaxed/simple;
	bh=Hq7XG4Ykfz7pEmUszbpTbvVQ/ZwNlA8FtyoeBb3Cd4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6UUH+gMm54d20VlRHybtErSeXGM6XLO77HlSORG+8FjOj9pUdGXMP54T/RfiXD8ktWMQtlsFRyxQIc34AILUM0C/0AXqLlvJJ0P7aoHBKHNinze4Q0H1ntoD+bbhaX4TE8whoivznZgZH+wOXU/w3BpUPBXcIc+8de+KITdWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ei61GXJ5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ei61GXJ5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3DgIwOhvzwGCeEhq7w7K6EzcRsAPUrRix3z5aztq7PA=; b=ei61GXJ5g4QDUz1q+tLEaiU3fd
	Islgyr3cOrnAP/NDRu6CPg/GDVmrjgBaifqsPZfTqoZDekbKJYLbrDZ+ESRxguhzUhf+oty2XHHdj
	s2EPoqE7o3aw3p8HZm8+yyUHV84g3fuE2NLb4EtEdmI7/F+pgdnzZbxAhjd3100/WxQCiYcNp5zH+
	d0phKyIVHl+VP1CyE2bH6vUJ1uEIr9Qrd0CRLsaBGwbLfwV4XIb6SWN+VhEa6kvzdcAdvDpNj+42X
	1qH2+rJsZC4W3HE7k3iZ/L/wg5qArHm4BdEK4G6+GhDWXQcHEdp7i3/Bg7cSSuQs5phc0LAcREYBe
	BH2K7Vgg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txGJO-00AAcQ-1o;
	Wed, 26 Mar 2025 10:16:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 10:16:10 +0800
Date: Wed, 26 Mar 2025 10:16:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
References: <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-NdGvErMGS5OT7X@gondor.apana.org.au>

On Wed, Mar 26, 2025 at 09:49:14AM +0800, Herbert Xu wrote:
>
> Let's see how your version is so much better:
> 
> https://lore.kernel.org/all/20250212154718.44255-6-ebiggers@kernel.org/

BTW, I absolutely hate how the fs/block layer uses work queues
for everything.  It's been used as an argument for async being
unnecessary because you can always wait for completion since
you're in a work queue.

But this is exactly the wrong way to do asynchronous completion.
In fact, now that async support has been removed because of
religious opposition to ahash, we now end up with the worst of
both worlds where hashing is punted off to a work queue where
it is simply executed on the CPU:

/**
 * fsverity_enqueue_verify_work() - enqueue work on the fs-verity workqueue
 * @work: the work to enqueue
 *
 * Enqueue verification work for asynchronous processing.
 */
void fsverity_enqueue_verify_work(struct work_struct *work)
{
        queue_work(fsverity_read_workqueue, work);
}

The correct way to do async offload is to do it conditionally:

	ret = submit_request(rq);
	if (unlikely(needs_async(ret))) {
		allocate for async path with fallback to sync
		processing in case of OOM
		return;
	}

	execute normal synchronous path

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
