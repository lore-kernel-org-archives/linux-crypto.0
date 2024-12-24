Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3FA192589
	for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 11:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735040810; cv=none; b=K3dtTubeu2MfRkNxiA6EaUXqnjvvw3IALbvpsQdRRRxAEPO9u4H/jwPLpS4PB5QJqFQjJ031PSSB4mxw2D8f8JBNFNM7aoJoYZKQt8DUITnKJITPoYviQZA0vaYu9jp6KSTAfSnVuXAJlvLZChY9D8meIeE6z+PaenhA6RF7hVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735040810; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KITOopA/YWQ02TNI1kgHOEN1r34SbHvCJHMnPdTD7JzZmGV9PEIgoZ48c7qgP2lzzF2QzXHcwPuD5NYubYz+YDZCuPOWhQ2+aPWDdfX18G4/fdyNC07cKtmD27qVpQ92/GT+BqNs3ZLdFEZdB0L+82KF9I+cxX3zVYYVmwtUwsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4361f65ca01so49832465e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Dec 2024 03:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735040807; x=1735645607;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=RJg6qoCxWg7AdezJbTNxF1/NFci6r3Cih19SFrztZhKF48LCX1xaMgfueByC/ZD21Q
         /7Pqnk8fUVpdMnDhQtjYqRziVbXDehnW4xnPfZILNDxE8x8rW0Z8RFF5q3PDl1S3E2uj
         pfezhWtW99IaucjfVeJwveKVLbLxJK9JOOjrQtUNlySKMIUlc7RmpsArowsG7iQWIIHM
         5GDt262H1n6Cp6GYYou9hSGeWHkcGlSp2yRdyzTNCbaKKwTe/U5cQDo2M0YI0RPewsYs
         tOqO2XWx0LaASYfgm5CQY8IB+gAAX5kDQLwXPGNhiy73ceJv/S6TcBQhJ+9EmU/DABIl
         ASdg==
X-Forwarded-Encrypted: i=1; AJvYcCXMKPr/tmfjiWXZdX2hRHi0gzYW4Uc9ksDsJnaVh3P6j5ONqsy3Vx+I59jl1wzsAvcgC3AzdjifSW4WX44=@vger.kernel.org
X-Gm-Message-State: AOJu0YykRqfhjtls73H+Jj7zW6PIqzTj7Zxt9xfQjImzu5mw+cXttIiH
	YpIFQWUei5CGhMXTVjFgY7lyoHij+s19dlIMlunj+e04qV5ZjOqBIEqASg==
X-Gm-Gg: ASbGncu8rZd+jhxhyAnV+oTRoAezNWbSDSbNkcLuxb/oh/kc+PTTKGtl1V0G1Clt7z3
	Ro0uJ1mHdAWGt0JllTQ6J06yXZgAjJW4/JmYWI+nDIMJq32jdjG3dQlXnkXYWLXn4b1D7RvtuBr
	Cru4e6RjSGknBdMAzRCdN8cVMi4A4I/0N9Es4hnK4hl2KprpsrfpexvBZetq1OPl0EeHl0BHfLF
	mEdBwCT0zv51wYnw8Z5VfbRgA+XWuJH61nPGtmPPNz/WPCwc4ozpVB94bZiesWqFXDta8EZ5CxE
	rjbTzo5Hk+E4NqZ5FjGyqZQ=
X-Google-Smtp-Source: AGHT+IG3mxhdxIBHpizO7P3i8DBlrTThWV893mRxCOCvHyRAk7XseYv7/Ui68XI4LgXPotmhIyjLuQ==
X-Received: by 2002:a05:600c:35d2:b0:435:d22:9c9e with SMTP id 5b1f17b1804b1-43668646335mr138640265e9.19.1735040806820;
        Tue, 24 Dec 2024 03:46:46 -0800 (PST)
Received: from [10.50.4.206] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c84840asm13931504f8f.61.2024.12.24.03.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 03:46:46 -0800 (PST)
Message-ID: <60e0f387-f6fb-4af4-be48-f380528553f8@grimberg.me>
Date: Tue, 24 Dec 2024 13:46:45 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
To: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20241203110238.128630-11-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
