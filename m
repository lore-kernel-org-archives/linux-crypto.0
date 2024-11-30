Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C908468;
	Sat, 30 Nov 2024 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732992153; cv=none; b=ClbrWJXJ4/iBMsnjnB89AIZ7JX43WZwpVrnZvAYczL7ASRVET36fUZk+yL5h4/Wtzsn0G2HlDZsK+xWiz9281qYMx8VyW5/4a8OUAYxW9AHOhRmQSExZd/dwe7eg0QWitxT63Mqe7GAKvjmuHoXopTw140Dgyb7kVhXOOr7NslE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732992153; c=relaxed/simple;
	bh=D6p86BJvkO66jl+eFjXlkmkqwKVitCZAmm4xk6RMu0o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lfa7jJptlo5QTK9gCjbDy7zTPvnKDGyRX3jvhzkYR9t2JqwIUswLaVax1xZdecs+Ch0fOiVZRnenA6Q/lxQpiWxAHRpKSRr3F/B+2KqBS1Y1U7b4TK9btqOT921awMUTqlM5hMZEysa5bbL/WOpRoSFzXSjIYkVfkNEQz+w0Ocg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPOro+Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPOro+Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D63C4CECC;
	Sat, 30 Nov 2024 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732992153;
	bh=D6p86BJvkO66jl+eFjXlkmkqwKVitCZAmm4xk6RMu0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HPOro+CzO/w/2Ktm3RGB/f2NhVOLXA8ZgN25OS0HqEusWEsMyNeRdc5I2QFhOTw/T
	 hTbXRoN8Zg/0f283OOmVIZOUxYeWWBJusFOBe4JmENnRlA3C64gmi/dfNuNVTgPl1B
	 M05FibU4qOjjltMFUTjoSl4QGsa23OdotwrwRsA4nFlkxWx+W7fqTQ5HEJFs4eED2a
	 qMqLSHsGd8eEHamC/81Js23Kdfgp8ohS+KLyNKE5Btiq0tHqfiBu4JkR1C3I1iOpcX
	 Ce05ne6zD3q3VuU7ZLYkxTr352BWeyUh2WFTNf5rU4u0R7kgmx3uPFzyHGKJJIrFHE
	 xnQ5bxN2M+59w==
Date: Sat, 30 Nov 2024 10:42:31 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, Linux Crypto Mailing List
 <linux-crypto@vger.kernel.org>, NeilBrown <neilb@suse.de>, Thomas Graf
 <tgraf@suug.ch>
Subject: Re: [PATCH] MAINTAINERS: Move rhashtable over to linux-crypto
Message-ID: <20241130104231.442cc1cd@kernel.org>
In-Reply-To: <Z0lXLs9Zoo22kH-f@gondor.apana.org.au>
References: <Z0lXLs9Zoo22kH-f@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 Nov 2024 13:54:54 +0800 Herbert Xu wrote:
> This patch moves the rhashtable mailing list over to linux-crypto.
> This would allow rhashtable patches to go through my tree instead
> of the networking tree.
> 
> More uses are popping up outside of the network stack and having it
> under the networking tree no longer makes sense.

Makes sense:

Acked-by: Jakub Kicinski <kuba@kernel.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 48240da01d0c..614a3b561212 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19835,7 +19835,7 @@ F:	net/rfkill/
>  RHASHTABLE
>  M:	Thomas Graf <tgraf@suug.ch>

BTW it may also be the right time to move Thomas to AUTHORS :(
I counted 3 acks from Thomas in the last 7 years. Nothing since 2021.
