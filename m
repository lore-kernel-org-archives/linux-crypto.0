Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D6333A029;
	Fri,  8 May 2026 18:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778264601; cv=none; b=BCYQqmtNgjAehraNGDKOv5QytKjjSG4hXGRh2s1ir67nj/mirl7fNGnCsKs7lFciSh2enB0QeauJFdjL8UGxHI1Dn8AixAY9rMmqH2fsibLln62dlp0mb9Oqtc7at4bSwWVxGEhloTn/DR/AQwlKYBNLUqJ6217UY5JERrW5VAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778264601; c=relaxed/simple;
	bh=tLEOzE3Pq/BpYLP/PubCHCFKDoLfd+JQAltLfnSlE3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1MbQW7OC7Tzq26awHkcxjST5jBj4aKMh8y6CEW577mlceD5JWe17UDD1OcpJpQkjTN1Ro2WWCmG6Thf5tac3l+taE5mU89KkTHXR4HqcLlJGPL4APR5loIyxiIMKLfjQgAtpSnWrOWx6HVFI/3jiqeUpmvIkg+5CO1KwyIU9DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdOpGjwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdOpGjwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5ABC2BCC7;
	Fri,  8 May 2026 18:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778264600;
	bh=tLEOzE3Pq/BpYLP/PubCHCFKDoLfd+JQAltLfnSlE3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mdOpGjwgAoidIursjyBrFoK2hKWxX7qYcybRgA6cwAeqloYqgqoDubdKRGjNu/vEM
	 SVEV7qsxDObAyoMrEPDLU3eHQtTMQI8HUi0w/4SJe1af4mSUaR+0XPm1TWGeB52Yue
	 nrKXSRqQBwiL5U+g7OVF1OJanFy3hmZ5hixFbBcPKuaPyQ5LjihKWXtxgIVSrJbNnL
	 qD2mTlak/080X6h+JQxef3a5stvT0tquhDxH1MjGZ9LlHyY7cGnFx82X7+XkaLFuPk
	 Uxiqx89vTyRMai+/G1ZtJzQPwrRhKsueWFOhOzA0n4+ZS4R2hTsOFIfqhPCRvxOmB1
	 HF1HFR3DNR69Q==
Date: Fri, 8 May 2026 18:23:18 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC
 implementation
Message-ID: <20260508182318.GA4145640@google.com>
References: <20260428024400.123337-3-ebiggers@kernel.org>
 <20260428024400.123337-1-ebiggers@kernel.org>
 <286248.1778263325@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286248.1778263325@warthog.procyon.org.uk>

On Fri, May 08, 2026 at 07:02:05PM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > +	if (skb_linearize(skb) < 0)
> > +		return -ENOMEM;
> 
> It seems skb_linearize() doesn't like being used in this fashion:
> 
> 	kernel BUG at net/core/skbuff.c:2295!
> 	...
> 	RIP: 0010:pskb_expand_head+0x41/0x220
> 	 __pskb_pull_tail+0x5e/0x2f0
> 	 rxkad_verify_packet_2+0xa8/0x190
> 	 rxkad_verify_packet+0x12c/0x150
> 	 rxrpc_recvmsg_data+0x1b0/0x470
> 	 rxrpc_kernel_recv_data+0xa6/0x210
> 	 afs_extract_data+0x5e/0x180
> 	 yfs_deliver_fs_fetch_data64+0x10b/0x200
> 	 afs_deliver_to_call+0xea/0x440
> 	 afs_read_receive+0x8d/0x150
> 	 afs_fetch_data_async_rx+0x12/0x20
> 	 process_one_work+0x18e/0x2b0
> 
> which corresponds to this:
> 
> 	BUG_ON(skb_shared(skb));
> 
> Presumably this is done because fcrypt_pcbc_decrypt() doesn't handle being
> called on a split buffer.  I think this may require skb_copy() to be used
> instead, but that would need to be handled in rxrpc_input_call_event().
> 
> I think rxkad_decrypt_response() should be okay because the encrypted data is
> extracted into a buffer first before being decrypted.

Yes, Marc pointed this out already.  Thanks for the review and testing.
I just haven't had a chance to decide what to do with this patch yet.
It could be an unconditional skb_copy(), it could be decrypting the
fragmented skb in-place, or it could be fixing up the RxRPC code to no
longer take multiple references to the skb (so skb_shared() would no
longer be true).  Let me know if you have a preference.

Also I'm waiting to see if the following patch gets merged:
https://lore.kernel.org/netdev/20260502211340.446927-1-n7l8m4@u.northwestern.edu/
That does the skb_copy() anyway, which would solve this problem.

- Eric
