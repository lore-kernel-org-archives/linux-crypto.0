Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F76019C54B
	for <linux-crypto@vger.kernel.org>; Fri, 22 Aug 2025 01:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755824967; cv=none; b=ozFhefaQWETgtKxhQ7XblaovSsb/q3DeTKHQEP36lv+c2881PuRio28lDr2c5I7f8cdFH7rn0EWl5J0ISD77Iy60TgfTBwOZsUawxf3Rktvju42sXG7eYsZ6HekE5Im7A/Qlg3IUfjBYmCFWmfIqeZewl1K0h36eRljgZcxHFFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755824967; c=relaxed/simple;
	bh=k4PCsDsUCHvA5vPL5ktK42szk/ObKfJNjwQcew+ZCiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHm0KlvdoXOHQvnM9PQdsBg+ygaD4SVTmWBdKNWhMl2cQkD1fLrM1EgrxhBWsDO2FqDosCe+s4ii0i3AjhP7Xwto4AM4XMtzx3NHjv15MiFYMpa3jtxoiefDPAJ7SZN8+tMXxcJk4L4dpCgXXQtvOM6sU12+Voibu6Gh/dVbvy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LY7Ljr7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LY7Ljr7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9512FC4CEEB;
	Fri, 22 Aug 2025 01:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755824967;
	bh=k4PCsDsUCHvA5vPL5ktK42szk/ObKfJNjwQcew+ZCiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LY7Ljr7SWfiZgHl2xEOrdQRdp7fR1j/52QnLDlgmH86R4OsL0SW2T/qQ+cXRTV2wL
	 ICLa4H5AvNrQVebj5lMylebpnq3Y/6YjYLmZ4jTcArBlJb+jR1LTTtMDMlmOd378jS
	 fri+m6P2Z2xxa+NnOf7Rc8EsvAGdmULpz7+xpiUGhgxCpoMyzByhAw4XgtG99/YEO5
	 tooV3andRzQZqj4M0FrPGJnKgkWW5d+gQtxeS9v4tzzbvtclT/U5k991hQoPHk8VMM
	 PlwCCUERNDoYCP3fhaaIbxKVL6bqzdFLUyt62GPH8XBqouFKAtzzjyXp1h+ZHtzn2v
	 JYMA8ntH5W8Vw==
Date: Thu, 21 Aug 2025 21:09:23 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Chris Leech <cleech@redhat.com>
Cc: linux-nvme@lists.infradead.org, Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/2] nvme: fixup HKDF-Expand-Label implementation
Message-ID: <20250822010923.GA2458@quark>
References: <20250821204816.2091293-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821204816.2091293-1-cleech@redhat.com>

On Thu, Aug 21, 2025 at 01:48:14PM -0700, Chris Leech wrote:
> As per RFC 8446 (TLS 1.3) the HKDF-Expand-Label function is using vectors
> for the 'label' and 'context' field, but defines these vectors as a string
> prefixed with the string length (in binary). The implementation in nvme
> is missing the length prefix which was causing interoperability issues
> with spec-conformant implementations.
> 
> This patchset adds a function 'hkdf_expand_label()' to correctly implement
> the HKDF-Expand-Label functionality and modifies the nvme driver to utilize
> this function instead of the open-coded implementation.
> 
> As usual, comments and reviews are welcome.

Well, it's nice that my review comment from last year is finally being
addressed: https://lore.kernel.org/r/20240723014715.GB2319848@google.com

- Eric
