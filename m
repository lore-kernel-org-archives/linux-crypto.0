Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6528A1DFDE
	for <linux-crypto@vger.kernel.org>; Sat, 20 Apr 2024 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713637184; cv=none; b=ht8K4lPfueUizjixiRrnX3qIjh4Ac1L8q2N+1grabXaBVvhACAjECgoFmxyiM4VnsrYi8LmqBJMD1sdQxPZBaiWtg9xaCdRJIcynZk9fa3hyjXUZMTszYuOcmWT1ZjkqJf0hc3or7VNg7Y/IjYaKmjZH7I6MehN1i4TnuxSPQdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713637184; c=relaxed/simple;
	bh=BMdXnEOYanaJkv2dxl2IwISChgysH2clKbvNEy1v2qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meDxxxf+1uoYmum8DV64MQcgjbZGuplrksQg00FaZbIfAWPDO9bp0S3bivmqW2ftExFoXCLze1wR6W/rshz+1J+4a9Dhz6bwP2VF4t7ZKFHYa+9mTJq1uYpdOUahdhPn1CbXoE2QKsz5GqvXIKuYHSwTjJ0H5Fqy7Q8PX+TVTk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZEiAfcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZEiAfcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B320EC072AA;
	Sat, 20 Apr 2024 18:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713637183;
	bh=BMdXnEOYanaJkv2dxl2IwISChgysH2clKbvNEy1v2qg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CZEiAfcUC/Qss7ofvzfw/TDwHHGSUGkwTkxQdsflFyD0a3/E2hxsNHQs56XKZduyH
	 j+LispvCW+0+/6ZNqXSQaED4is/QWjUyn95GtGiiNum4dkqSrAwg8vHH+RI/40Uj97
	 Qk39OsvTbIIgLOFqOH1JZumJH/vYcCI0YUfsleUyWxIZhnOCZ0TIHS0NY4l92iDu/w
	 74nFZZUCxpVu0qNzLI1qOs3wsSsOUc+slB52dY5XaGKJTb4QqnkD1yUsjuXQ6lkK/h
	 9BXuRm9Db1BTdMY3bdtBqEy6OBgRYw5vRJiqIWe1M/yxIK+ZrNEXhhsIgJtXeTnRTw
	 aeMz+0ays89ng==
Date: Sat, 20 Apr 2024 11:19:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aes-gcm - simplify GCM hash subkey derivation
Message-ID: <20240420181942.GA786@quark.localdomain>
References: <20240420060037.26014-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420060037.26014-1-ebiggers@kernel.org>

On Fri, Apr 19, 2024 at 11:00:37PM -0700, Eric Biggers wrote:
> +	aes_encrypt(aes_key, hash_subkey, page_address(ZERO_PAGE(0)));

Actually, page_address(ZERO_PAGE(0)) expands into a surprisingly large number of
instructions.  Using empty_zero_page directly would avoid this, but there's
little precedent for doing that.  For now, I think just using something like
'static const u8 zeroes[16]' is the way to go for small buffers like this.

- Eric
