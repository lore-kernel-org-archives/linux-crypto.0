Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61781EE034
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 07:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742456956; cv=none; b=bXu6qd+SyMqSaatsUjUHXBl8S4qmBGshsJPMo1Tlt1h4hKpIDf3XUkRPkuM/0Ido8oei/AIA58LB/LNBEIi/PrrGGLJCVlUJX6XvhQTUArGR/yk3i2/ysQIs/0ASDTTOWBg48qMeaIxnftVXfq/GJsYbcqEXkyQA9p3hUbAvYEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742456956; c=relaxed/simple;
	bh=a7YStYLDt1MQc0XyOEtQyoAKdWgycEstL3mWW6wovyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HY60Xdjie+1I4Hi9HVl4H69Ok5QP4t9K1olPr5iw5ADJkqK8ZPyEVy4acZVQaOEnSc+UcGVreBY1gw4eIlm3ZuEEtz2izE6JALsmb5XA+EoKZwbh3fKXkO3vSUotMOTA22ryymiPrBpQo6ZXkilSX/lbeVyazYGTBZfrAjfxrkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7BhY+Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7BhY+Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A66CC4CEEC
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 07:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742456956;
	bh=a7YStYLDt1MQc0XyOEtQyoAKdWgycEstL3mWW6wovyM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=l7BhY+IyMSoCwE0JKy9nXmx725Vp3lLR6ZKbCgj7vB62BlemjqD2sCJJFx59rO7vz
	 c0Vvf7iIK+KixMx9Z83AfGTwgyDq5SoT9k+ug2JhnOe1L+nakEVo/pGGFsYy1nunoM
	 9rqr2P/zQpWvwu1JGaqi4qN9LEoa59+eKvduw9JY5+EtyF3emrUrAl+DAHBmlGv+in
	 D7W33eZnOEzZ0ksYIuAiA5vYi+MHGVoaFnqUEy4zsRCmlX07wnJjBDWR5IA9LxmlBo
	 T7w4edqggFfim/KG0BCpJ6iIBNQjST50XCf8LVlvR08qejGNKB7VNPmfTKPGl7mvQT
	 5zjIlTB9r65kg==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-30bf7d0c15eso5514401fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 00:49:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YwGvgzXdWdXJEjGKbHfFXhqkzELqZYvusisssaQ+mxCzYPt/Ek9
	i3EbgkIfSjb9yYBrBlLk7nETWORgKMjCdnhsNwIanqx0DqHyn0TspZJcIRoKUxSlTJ7kg1KuWC6
	eNs1jZp+6/gO8a79Bx5N4DECOzUY=
X-Google-Smtp-Source: AGHT+IFj3K3rvUnH5qn4dYKltfywBLhp3KtaPOZ5qWZ/6hB8z5OVSSFXa6SfkR0PPZfrLcHQeZYzluQNozBlAeDmrEI=
X-Received: by 2002:a05:6512:3b10:b0:549:6451:7ea1 with SMTP id
 2adb3069b0e04-54acb1d0e5emr2308347e87.24.1742456954614; Thu, 20 Mar 2025
 00:49:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1742387288.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742387288.git.herbert@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 20 Mar 2025 08:49:03 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG7kJfQjq_Gm9fM4Rq3yO=f7a056hiKsTUJayJDP=7VcQ@mail.gmail.com>
X-Gm-Features: AQ5f1JqQRuqBo21zmAhTzQyTGlCQlXuUn5kcymCkUUg4-NRzLV6OX8hQ_XHmmLQ
Message-ID: <CAMj1kXG7kJfQjq_Gm9fM4Rq3yO=f7a056hiKsTUJayJDP=7VcQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: Remove cavium zip and drop scomp dst buffer
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 13:31, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This series removes the cavium zip driver and the dst scratch buffer
> from scomp.  The latter could use up to 64K of memory per CPU.
>
> Herbert Xu (3):
>   crypto: cavium - Move cpt and nitrox rules into cavium Makefile
>   crypto: cavium/zip - Remove driver
>   crypto: scomp - Drop the dst scratch buffer
>

I haven't followed the acomp changes in detail, but this series seems
like a welcome cleanup, so

Acked-by: Ard Biesheuvel <ardb@kernel.org>
