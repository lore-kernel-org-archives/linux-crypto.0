Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF24149C4D;
	Mon, 16 Sep 2024 10:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726482398; cv=none; b=hm/MWvH9aa9vPWyZX9oPncW/5VeTIIwbd3RUn7YVxd1z1fwlxfnD3meCAZVjEIUxiO7XOWp3MCxGiPUVYVwWIIi1MzD8t7nHWfp6Fn5cqXgQnNHNUWDWk0ckkyeSxw0ial1uzNppEvp//rq1Y5L5B+gwZqO6m9MxSqC6sAyErMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726482398; c=relaxed/simple;
	bh=rihM90jE9xux99jJPb6u9Diaof6Sh3nQQCoPkdfZnHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhyXQfU8pTcQTpokH7kxvLuK/sPslByU2E2F0r16CIaRhX4GqSElqV6dGnBMTmAqbvUuk7JWVdI6bV+1wYza+DG/VQluhtuXaMlepijUfBSNbSYxmYoVtFZRZ0jU4mZtRN8dSqeKFJaQIhgNgQ80VM4MQO1sxFoOTIvbrZyEV1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBaS2rbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBaS2rbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D503C4CEC4;
	Mon, 16 Sep 2024 10:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726482397;
	bh=rihM90jE9xux99jJPb6u9Diaof6Sh3nQQCoPkdfZnHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lBaS2rbth+P2EvFkSEEHZChwVGCuwOAc7XH2yPSapx8eYD89Qw+Mycor9dJ1bd8HH
	 9VVrF6IkLOb5b11RnZA1s0TgvzF1l7HxlPRG0SKWrwbhU4OUPSlKOZMhpoeOCNN8Ze
	 T1zbg2VrQXgs078mAGxP+/eepzLiCFDcRK8dZc6Y=
Date: Mon, 16 Sep 2024 10:33:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: George Rurikov <g.ryurikov@securitycode.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	MrRurikov <grurikovsherbakov@yandex.ru>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: Fix logical operator in _aead_recvmsg()
Message-ID: <2024091631-quaintly-scouting-3c29@gregkh>
References: <20240916074422.503645-1-g.ryurikov@securitycode.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240916074422.503645-1-g.ryurikov@securitycode.ru>

On Mon, Sep 16, 2024 at 10:44:22AM +0300, George Rurikov wrote:
> Заявление о конфиденциальности
> 
> Данное электронное письмо и любые приложения к нему являются конфиденциальными и предназначены исключительно для адресата. Если Вы не являетесь адресатом данного письма, пожалуйста, уведомите немедленно отправителя, не раскрывайте содержание другим лицам, не используйте его в каких-либо целях, не храните и не копируйте информацию любым способом.
> 

Now deleted.
