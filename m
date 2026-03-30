Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46695333730
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882928; cv=none; b=m6jvGoyIB+V18RT2pGadINhuB6XKjtil4nPw3zGDqnQga2R1FOWaDCUlcc7PtulFqJ5EhMT7rNLxFy5bf8HXx8E37LZ2aIvZMWjPK/BHixB5Gq+3ju3gjzkC87eAFunXKXRM/fQ+L7aHWHQ+wmhq99Kwlwh7ORfzk6j87T9rQYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882928; c=relaxed/simple;
	bh=fVkuWa4a6/cQxsnJg9pRm7tn6P2ndJyKnXupZf2dZoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ac1eIUuanenXO48ATp3efLRN3PNgP3j82NBJmTSUtfhouJi6RuWyXGZ7Bu3zPPbXFH4pzeMbZfdbyGwEncqI9DXi3b6ZhldINNNKTUtvWsUwuCxG6pZCMyQmWOzaDr4BkSPY1vqHomodOcJkhhO1BskHTejMpbR26viI6HkZp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cSnCQC1v; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJtfOKq0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cSnCQC1v";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJtfOKq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774882926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ioaGBccEulsVefeHIBPg305ScRFhJiChwS24LCLi1yU=;
	b=cSnCQC1vC7tbWlnR4vS3hUzdtWwdN05EhRHEFdi8f2wxvYX8N01fzjMUeueCxuaz9C2MUo
	+9HNol1PtSbr9gyMEs0Ml1ktxJuptQ2ImO8YN2pheHdd6FRkoEoO5c6euEt5vY6Qqxy3Ev
	tgl/DMwjp4yC23YlukVgqSxebZ9fv3U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-JK-R1RSMNRyINHvfd_Pfaw-1; Mon, 30 Mar 2026 11:02:04 -0400
X-MC-Unique: JK-R1RSMNRyINHvfd_Pfaw-1
X-Mimecast-MFC-AGG-ID: JK-R1RSMNRyINHvfd_Pfaw_1774882923
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89cd8b56114so13749386d6.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 08:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774882923; x=1775487723; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioaGBccEulsVefeHIBPg305ScRFhJiChwS24LCLi1yU=;
        b=cJtfOKq0lZ6i/yu1JBQBHyPriJHNaODHTnTGIib5Who8FQp5rOcp+wqs9D7SX1NGkG
         iyVRNVZfSBfmmYosF1xa3GnCi+k8+V5FW90GnpRJv771BB6wTIeBjyxGCrjFIpQIIrC/
         Jbjei/04AEHcqITxrB3yLMUrqBHKDkBnTXxnwVwQDJwGYHZ+8r57C98aQpsPdBzk5+Js
         EaLDPIiqtSnw5oqHJBY4QfxXHVDXzS1zxrlvLciJRJVtYTqbFeOynMObjrqEsyvug9B6
         m3FM7+wMxIOQEVEXTrWHfBWbcYpPAlZATqVbnEl6tkGiD9MalCbrEKljYcwljSDudkFy
         iL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774882923; x=1775487723;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ioaGBccEulsVefeHIBPg305ScRFhJiChwS24LCLi1yU=;
        b=jAvqwwsmehUzQ3wqbs9K8iEWSHIHq2yWOpQX5Px9jIPVMyZuP5O0+KRTsTEf/EwoXa
         BNsnUaSkWytRP/dD1CAchW6ln0qooCOwExQhZC9yD8rErwJK2ZB34c1H+mI01enIPouM
         9cLJMNp452zfwiZY933Bq9dyHRPtzkNk6mXIryrXRG/D2WEjKFhKoxS9B6bWPuhIZphs
         g50lm1zaR/1O394SkTa3r0AiT59+OPydg3yv6nrVVwFkQ+LLd/bi8VBCZcs1ArmNZLhj
         Fwj8AScC98iiNZRPxFU+G7UuQ9HwI2X9Kb0iNltYibJ5B+WGZ1zUeDpVjq8n56Uf7Kqo
         FdRg==
X-Forwarded-Encrypted: i=1; AJvYcCU20a9crWKLxDCUY3VTmM/vf5xiHixq1Ie6Jbree1MIQ+Z8b0dAxD305AtyAsMorbCs8K6bCYuQ2exH1kU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjV6pUfMl8Xi9hJwzsnrtL5Av56L/yHX2b3VuNm5GzQxOk93Q6
	JcQ+kdI/QZM61cmUIUrbsF5xhHJudvfyFWVjZakejIcAH86VKlFCrDVihIjt87gdYth4fkSZC3W
	l1WL0D5BERvpMu91zxM1pFZq68B7sbE7QMgHjeQVva4osKyexvgh4eV9CkkrHXQmdXA==
X-Gm-Gg: ATEYQzzR4c2jHQ5ZAL/a/TWwKgM6kmBxm9TpuIRobXhtTIJ2UvkwiaeimjfeXwB7+in
	/3pnNsn/rnHlYfyBGRNG8vYn/cJNUmvxSi2O/Hb2T4z8ZUL/gJh/MG+3Jkjo49QpW2CJaxrsVwW
	jpGgdmpKyZpmkG4w+RZAFcNKBWhnXA4IJC0mOYa7Uv/j0R4qkrGtxUd7QEaf17JboIyktu9ko2k
	0LJniLf7qcwXBUeJUTzUsKHkc0ya0hoMLcYgOcTk/RQ+Yc4OriJW15MAx3iR2lOGVTZXNyyKum0
	0gI8WZWw2pjko/PMZf81zb4JrN9nCxASy77pZnAWM+uDJt4Kg8jSKB5zY8Pi1L5wHzHEtHpvLfv
	GYmVBfCYLu1TE/Y5f1e5UBcdGu5548Y0hMnPYGZpZ//TBVhyqhYFeAoMj
X-Received: by 2002:a05:6214:498f:b0:8a0:7c8:409b with SMTP id 6a1803df08f44-8a007c84819mr89272166d6.33.1774882923332;
        Mon, 30 Mar 2026 08:02:03 -0700 (PDT)
X-Received: by 2002:a05:6214:498f:b0:8a0:7c8:409b with SMTP id 6a1803df08f44-8a007c84819mr89271186d6.33.1774882922650;
        Mon, 30 Mar 2026 08:02:02 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89f49cbb8besm57387836d6.43.2026.03.30.08.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 08:02:01 -0700 (PDT)
Date: Mon, 30 Mar 2026 11:01:59 -0400
From: Brian Masney <bmasney@redhat.com>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 09/16] clk: Use the generic OF phandle parsing in only
 one place
Message-ID: <acqQZ5sx_WZrr4KJ@redhat.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-9-5e6ff7853994@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-9-5e6ff7853994@bootlin.com>
User-Agent: Mutt/2.3.0 (2026-01-25)

On Fri, Mar 27, 2026 at 09:09:31PM +0100, Miquel Raynal (Schneider Electric) wrote:
> There should be one single entry in the OF world, so that the way we
> parse the DT is always the same. make sure this is the case by avoid
> calling of_parse_phandle_with_args() from of_clk_get_parent_name(). This
> is even more relevant as we currently fail to parse clock-ranges. As a
> result, it seems to be safer to directly call of_parse_clkspec() there.
> 
> Suggested-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
> ---
>  drivers/clk/clk.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 591c0780b61e..93e33ff30f3a 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -5375,8 +5375,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
>  	int count;
>  	struct clk *clk;
>  
> -	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
> -					&clkspec);
> +	rc = of_parse_clkspec(np, index, NULL, &clkspec);
>  	if (rc)
>  		return NULL;

Reviewed-by: Brian Masney <bmasney@redhat.com>

In case a Fixes tag is warranted, it's not exactly clear what should be
used. This was introduced in commit 766e6a4ec602 ("clk: add DT clock
binding support") in 2012. However of_parse_clkspec was introduced in
commit 4472287a3b2f5 ("clk: Introduce of_clk_get_hw_from_clkspec()") in
2018.

