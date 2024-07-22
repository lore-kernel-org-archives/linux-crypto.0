Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11922374D3
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2024 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721687305; cv=none; b=rfuHGSoGTfjFuc/eIn8kVbf0frCijRH4ZQV2CZ3q3bJlPOoQRd48B4v0dgp4P5sKcEXxLbOKYbbekh2JXtPS41W4FA0rZJClgcj/wAY6v1kJBcuJf97Tpyz42V0iHi3WpevzHGMhuFGviyp2hj4+F+903DAZDqUqtjhRz9Hqsvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721687305; c=relaxed/simple;
	bh=DiorJv7n85mq93NrB4uHNHaSNBzJ9vO1L9Ub7UPLr0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HI4NeWSwSgEkvPtgq5GMvPEfw4Nc0HFWHD3+TNVXSK1nONAx3xL2347pqkNdYiyTTvGjAXieVld6C/owZ0YgfA4hwseCAni2DLKUaq8dYdvtKr9YV35FLkhOaTg5Hd7uQrp3yOMewvqEzEIvrjgfROh0WuyvgDu3ZXWGAs2uRf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s8RijMTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s8RijMTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DB7C116B1;
	Mon, 22 Jul 2024 22:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721687304;
	bh=DiorJv7n85mq93NrB4uHNHaSNBzJ9vO1L9Ub7UPLr0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s8RijMTa+iqo+AFG/Mv8tf3ulM91Me2Zi8TVEsItw6DVjImlYEKiLD3M5mjnQTkNh
	 zhn9CcgJdR+l+k9xH9+q3ay+lNAbEkRt7iDmx9cM8NgIoFtU1WG6HKC6IAYzHZiAVb
	 PTOrdG4ZaPLU8hca71OFbMnszO5CEw74uZvQxjtlz67xsSQuCE77gjp4TxUHCeUKl7
	 eMr3v+G2i1cYLfKcu4LdMQOtCG6mbU2o4YKQfSh3Jrgu8tMvX+zyBM/vYTKh29Q1nk
	 6l2Eay98AmxXN2RRPxjxx8sbhqOsi9NWtqp8xFgINIbeSSCXzaKIH6s6RmV9JBKfDV
	 14WoeQM3viLJA==
Date: Mon, 22 Jul 2024 22:28:23 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 0/9] nvme: implement secure concatenation
Message-ID: <20240722222823.GA2303815@google.com>
References: <20240722142122.128258-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722142122.128258-1-hare@kernel.org>

On Mon, Jul 22, 2024 at 04:21:13PM +0200, Hannes Reinecke wrote:
> 
> Patchset can be found at
> git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
> branch secure-concat.v8

Not a valid git URL.

Also no base commit given and this doesn't apply to upstream.

- Eric
