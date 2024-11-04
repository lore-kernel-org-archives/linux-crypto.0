Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD4E1C3038;
	Mon,  4 Nov 2024 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730736676; cv=none; b=Ofeyr+RTKYmsa+YoBC1UfcnNar9ELxj3lx9ctWv2RlzUnUw5XBfrybAOvY4YIbzcJYdlQbMECMYFA14GhWwlEvj/uHIZKCmcEa9lq5G8GVflZpnKiwywyc17pbGR73y038UJnJAnJMT+VGB2L5ou//UYTVBLU61SBlR8oNxbEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730736676; c=relaxed/simple;
	bh=jbyllvauex8tqMFMdTXvyGQZhUUfwaEX119Q+OwRS8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPVtgA62RZ+XFB3BIDUpfWK/ZYMkZuWPzjFWu2STx4Tjw9qXhhWcfXsXyJDLEwex1f7xDhNJ0fVdhXiv0cmmkdo/djIzLPAQbBaFZdlPVqYSQ5UMpj/nwSqNnlrL/69dlLZaHjSMJGGdIB36kKyN6dIvLy75rHTWpnpDjj9Oa6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPSqAL9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPSqAL9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB9AC4CECE;
	Mon,  4 Nov 2024 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730736676;
	bh=jbyllvauex8tqMFMdTXvyGQZhUUfwaEX119Q+OwRS8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WPSqAL9r7pR+YYgkjx32AH6bnZwqoXvXuHe/u3PpYj4MhpV0Im/igYgiP/e4/0jm6
	 zGvkvBkHDYlrVGdmTx0WomIU9b1rg4A9JYT9Br8Zt9hKhdjVY9vE+YND95au5U9MMf
	 feL6CE8owPys3IPt/U7E4h8OlYuEjJRYdRyWwPy/eNaw+PcNn14UeKXP2qA5FU3WD1
	 80xjzPxXRuw8EIwnISGJBLSWTcp8Tvziz86C7rmecrIvGMwIlJNTHY2/NlnK2cCIeh
	 tOhs+1WJ9pknlx7l3FMrLr6kLK4LLMZSzQ2fN3hHMSZ9xuEWXKWAeZgvVtqOLLQyQt
	 kYDrgeRDu5zWQ==
Date: Mon, 4 Nov 2024 10:11:14 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: upstream@airoha.com, Antoine Tenart <atenart@kernel.org>,
	llvm@lists.linux.dev, Will Deacon <will@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Bill Wendling <morbo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v6 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel
 EIP-93 crypto engine
Message-ID: <173073667299.300346.12132353760971181964.robh@kernel.org>
References: <20241102175045.10408-1-ansuelsmth@gmail.com>
 <20241102175045.10408-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241102175045.10408-2-ansuelsmth@gmail.com>


On Sat, 02 Nov 2024 18:50:34 +0100, Christian Marangi wrote:
> Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> 
> The IP is present on Airoha SoC and on various Mediatek devices and
> other SoC under different names like mtk-eip93 or PKTE.
> 
> All the compatible that currently doesn't have any user are defined but
> rejected waiting for an actual device that makes use of them.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> Changes v6:
> - Add SoC specific compatible
> - Add now supported entry for compatible with no user
> Changes v5:
> - Comment out compatible with no current user
> Changes v4:
> - Out of RFC
> Changes v3:
> - Add SoC compatible with generic one
> Changes v2:
> - Change to better compatible
> - Add description for EIP93 models
> 
>  .../crypto/inside-secure,safexcel-eip93.yaml  | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

