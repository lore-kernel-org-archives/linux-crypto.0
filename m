Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A21F3FED
	for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740055682; cv=none; b=UndM8WAto0Gz2ItKv0iyBufz48evmsOXAHaqLrDgqSajErT9dwLJ8vyHGo3sHetQwgUVDH0XgtmcMjsM8PYKTjLiHaO2gFa9A4KG4nQtAYKQ6Xts7rzzti9fiOjE9zFjcDQUy6LVowY20DSZZbIbaDxQdPvvVdESoEPseY/3dsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740055682; c=relaxed/simple;
	bh=HfiQu/e9OYoDP5LE2IQ2WrA/SQR7aHF9x517fW1MTNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PREw2vW9F0PvfygsCOOGhrxUWav1mRKL3nqgCFG/ROS8LNeHTIp6z/fzbj6/pGL7f17L/qyW0J4rsBPYf2hE3MYcb5uhVrDa6X3nLw5Vgl0yeaOMQBfT8s2WSHZQ5py5G80weSUVI2dJEy5Hfp44sL5gfxna2/gDBVM1T3Ambcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lejZZhPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lejZZhPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1BEC4CED1;
	Thu, 20 Feb 2025 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740055681;
	bh=HfiQu/e9OYoDP5LE2IQ2WrA/SQR7aHF9x517fW1MTNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lejZZhPDIwHImFW7BOYmqh4dFN+iFwFw8+uwl1macPt2Pzf+f5CX+w6vFF98BXaAG
	 iK1Y1dhaPG9RT32XJuHHYV6wOq4nYqYfDAHlCzobRU+toCQpbr3yYnW+mWmdESE0g/
	 T87SnQXhiNl+hfgmy4szFuOWTQ0SEOJR6kv8EWnPA2neTbkwQ7LKjrzETXDg8nrsd7
	 ZVJBoKk2CgFhVzsfoK8wK9ZiMA+8I7DwAz5S8HKI5we6xAqKYBGIMVMEtzDzIzfD3w
	 1ccfpqUmA+qQvNC5m1wMbH3jHh/LfJYk1g7GgIxGGbT21XvBOFUslhbR9LbK/Rn8d4
	 0yU4zEmiam3ow==
Date: Thu, 20 Feb 2025 13:47:56 +0100
From: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>, soc@kernel.org, 
	arm@kernel.org, Andy Shevchenko <andy@kernel.org>, 
	Hans de Goede <hdegoede@redhat.com>, Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, 
	linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/5] Turris ECDSA signatures via keyctl()
Message-ID: <owevknlvu3slxa5uyh6myz7qqpupwrqditsqvipwbw6k6z5sly@3rwki2sta4zl>
References: <20250204131415.27014-1-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204131415.27014-1-kabel@kernel.org>

Hi Arnd et al.,

any comments on this series?

Thanks,

Marek
