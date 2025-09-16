Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109A2E571
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757980941; cv=none; b=JUnWsZ53a31Ipb3m6N77mBJK/iWkkps1lgH/tXtXbe6IDf1mZ7hly3Wfln5ToYyIK7h7ih7TxQF2WTK8l85HjjbMiVuI1hj5XjEXqmSmolM3RXVBZmxbUPOXygccY84Ww8Z6MAhLKrydRTsTQWP+Ye1yT+ljQ2PkC5oeEYiH1jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757980941; c=relaxed/simple;
	bh=ONGLoJVIPHA/jW9FBJpkiyr52N/UW11YGEOInd3wTgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHQZmAkrcTczqnUDGJm6ia/sCim0jO6cCfvb4KOvNvQ4bHPhVA+2MEJmVG52WsQnNo2Q7zisfwvF9qRjyQoVACMVZkC8Qr80wxhuX9YNWC0vyMb5cgumiGwJOp53ni2gpEKwpndaqr28UPVzUa31UEgDrYeyUUengp//iNMkl+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0/6wZG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0/6wZG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE7BC4CEF1;
	Tue, 16 Sep 2025 00:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757980940;
	bh=ONGLoJVIPHA/jW9FBJpkiyr52N/UW11YGEOInd3wTgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p0/6wZG893erg9AIbf20nqptKxAybqZHTut4JbpTBcYxD/BVa0OfaV+d2tby3akAW
	 2SeQIrwRhc5gT44hFylRU7+/jn0/ruIsLztE1UZdxMVA8FmEToIVCRXnrlb8aItJDM
	 YTN83o68jZPkJ9nT4nInGNCaA/OHopcxnKhT2H/tpOcJ7qwM+egveXrjU9HF/9LlGF
	 6Mn39XjX27KXnrx+8tErCuO9yUOCJpUhAuabCSu9FgpbhP3x+tWn0Iy/tz5B2Rvte6
	 aCbhOU8fjMAk62ICphW4M33wIFeAYEsjyv3qQnNtbMmgjFznQhsOsO/4XwRwmwzZ1H
	 2CiwXAtNjqlJA==
Date: Mon, 15 Sep 2025 18:02:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Chris Leech <cleech@redhat.com>
Cc: linux-nvme@lists.infradead.org, Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/2] nvme: fixup HKDF-Expand-Label implementation
Message-ID: <aMipCom_QsczFx9I@kbusch-mbp>
References: <20250821204816.2091293-1-cleech@redhat.com>
 <20250915-expectant-limb-a1464f3a1076@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915-expectant-limb-a1464f3a1076@redhat.com>

On Mon, Sep 15, 2025 at 04:17:49PM -0700, Chris Leech wrote:
> Bump and a polite review/merge request.
> There's been no feedback requiring changes in v2.

Sorry, I misunderstood the conversation to suggest this was incomplete.
Applied to nvme-6.18, thanks.
