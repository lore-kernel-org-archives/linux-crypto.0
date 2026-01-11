Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843683358D2
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768140299; cv=none; b=EbxbeCF0RrKXdV/jQpxlza8c/17tBx4gTOnggSSdvWZSkH+2i0gwwYbXYtMWq+hIBuNYXNbjziEtzqrl6HVmEhqCJ1NZMlKgw3VGrbIBKVMj1ASYtW7wVpg4cBhP3+Pezdf/j0aK/2B++Rd7PGfN0WX140Fghn5U4ol81Y1HNF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768140299; c=relaxed/simple;
	bh=btyv13yF1O8eLHTxPRhdfp8TKAEfJvTKBJK1fYmI6Xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nb3Hgx047uv16cm0NAxxiInA5JEHjIfWkMGv4ylp1U0jh0ZuTJ2gf3poFjOtxK2b2wNDgV8U95bvfk9Q3uBVkpswqqVuQMnA15Qm7vwnp+koA4sM6M2XbevLa7/x5Sjx481yQEpVJrFmRhl66pBvIheO3ZtMVGJywEHWiVl2kAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=QExsiGGl; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="QExsiGGl"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64dfb22c7e4so7701024a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768140296; x=1768745096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0XwABaHQba0TZXE5KSskxvkqQOly72ac18mmHR+qtCY=;
        b=QExsiGGlElrMbdLuVLF3vOqHwCf+WCT61him0YoQoIEWfiO4yNLyd4VPBUAKN40Gej
         x+S845X0jv6JN0VBlI7arOrMRZmUjNjdywGxqg5AZeDp411nr7Ct3jMkAyw9oGfZ80tp
         9peF5Nu7BK/4h9jjmebrpbIuSLELKFU7zvnFZqdA2gopeWLxeGHjMxwhymx3RIJ7uMfB
         hpCmIW4/qAYok/gFj8dEiDrfBxbl4cYeMBaBpOEfsfmWLMvsLKPHH+jcF56wU5GfMxNT
         Fk83jkyDvYSwRUyk76cF/DEUlxrfU34/Cp8JPQf9+99HmKUb0Ee91SKnRcSXxBM8h+ZI
         d3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768140296; x=1768745096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XwABaHQba0TZXE5KSskxvkqQOly72ac18mmHR+qtCY=;
        b=EAdhPSvzpKLbDkuDC83TGG2URWVtNHqvqCmUw+IGz3NY8cKI6HgCe0jdvyXzoeFdWF
         Yl49G8hTidoT3RIdwWS1yyWhlLRqwZAVPPshL7SI8B8+9qCBJJhMWpdrnvsrD4Knu8lH
         3K9RGM+G3CTd41GvA2gZi2b7SZ96TYSIjnpMS7gXP+tf17hPsojmyQJptMTqfKTHzF/0
         8JaLrJjuG8FwcIJZacDtNcngj0HGzqAfX39Bk1bdTb4UqOJPjwT5lP5vcz/kxvDJuS7u
         yJAmyfZ5a7xE2Qu6whO1kaCXGewA6NtrFY27eCfuPnSwu8SDh7rTewZuMep5CMlP5jvE
         yHLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnyPSA8OSUL0UUnq9LTqDfuWp1FUINuBd7JiB2Wmt37bYRYhR2gl3Z+FZIANTXID9vJPSA91mFeegkPQU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx+HeUl+YVKRZGBGRQF/ufwdQa6iVg8cAO+coyrOxUyyq4NUxv
	o163WBLxle0QhFdGrlE1Y49Tq6fuSwtlkKYJ0ZI93PPDY4aC0MflVp6EsKkP7/LumLE=
X-Gm-Gg: AY/fxX7rKg3t3Uawdoen5KWbMfd6VhUxsHPEiRKot2whPe/dUA3WlBcAmEn3quuDV0a
	08j5gRuXqvu46DStLRiCHNsxciJPiAylzOqcmh0lKzU8KsuA24tLIbw5bA+dohtEQ9B9wIPkX2F
	qNereL3ZsKtSu3e/B1iGcWDB2C3ZrUs0KvAo2JapeLCINZ68EA7u5FuaHLhLSegKRkrQV4nX6Is
	vQW2/Z/HeBP6252BqKlcg81yqmazMpptJFL8D2DEVLmVCotiv95kv/A0gXZHLzn0LthQ1wy4cjq
	TKW++CJuul1YsvZdeQtj3uEs+eKlUh7NopJ6CvA8bgmc/Z8V1FtMRh0XYsZRGg9G+/t05Dhn7ZM
	j8ApzRQZYjStgYaO90oUiC9GqNTCn4tSu0S/YJt0+7vVQR9+3ZnZdrGytsY8nFcOZ0FAto30izP
	ZUKZRb6rM1HLL0N4BxOaz53JE=
X-Google-Smtp-Source: AGHT+IFH0IHMLB/e9VMPw+PNQvxklsKe4TmQmjkQDY/3vRiOU9XAUjD+Bmvv1dPy8Ir0WmHAJUU9Lg==
X-Received: by 2002:a17:907:a08:b0:b07:87f1:fc42 with SMTP id a640c23a62f3a-b8444f488f0mr1766243166b.16.1768140295378;
        Sun, 11 Jan 2026 06:04:55 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86f0d6d7c6sm455055266b.42.2026.01.11.06.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:04:54 -0800 (PST)
Message-ID: <3f82d755-552a-4074-bee4-b2660eb6a979@tuxon.dev>
Date: Sun, 11 Jan 2026 16:04:47 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] dt-bindings: usb: Add Microchip LAN969x support
To: Robert Marko <robert.marko@sartura.hr>, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, vkoul@kernel.org, andi.shyti@kernel.org,
 lee@kernel.org, andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, linusw@kernel.org, Steen.Hegelund@microchip.com,
 daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
 olivia@selenic.com, radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com,
 gregkh@linuxfoundation.org, jirislaby@kernel.org, broonie@kernel.org,
 lars.povlsen@microchip.com, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr
References: <20251229184004.571837-1-robert.marko@sartura.hr>
 <20251229184004.571837-2-robert.marko@sartura.hr>
Content-Language: en-US
From: claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251229184004.571837-2-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> Microchip LAN969x has DWC3 compatible controller, though limited to 2.0(HS)
> speed, so document it.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
