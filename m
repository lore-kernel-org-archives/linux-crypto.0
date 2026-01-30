Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D1C2E06E6
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769785426; cv=none; b=FDnyMCUMbq6pGzuOHWStd2aitzwG+cOkijHFuaZRIm/RULx/ceizDtPvjhadekNjFXpc83XLHO1mLUxaTbOra9NGoSqVPteDIPgCfOhay8kgqnK7bjkyFDhwciqN53yrVs/CLqtumnvvPiwhUAsFO/KgLUot9mBBjS0cRwTSxbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769785426; c=relaxed/simple;
	bh=thq0kwrsVjkmoBy4Hq4IMi59MV9M0Mi8MaVexvz33lI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RoOnEZ3a7um09VPURxFUavxYc2jKBFGlCc7vYvd7kR6QsAJ3cAORJyT0GQEmVJW6ZQ5lrsNm4RJKgD2A7ri5Ok1p0ivi4+h+DvfrEQ11Xyj5rNanbQk65EuyRWdIRfW92FdXU5EYdlw0Nx1cVozm8dthQdul/wYgq4aXxdMHZFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f4NeHSWX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f4NeHSWX"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-481188b7760so15576375e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 07:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769785423; x=1770390223; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=thq0kwrsVjkmoBy4Hq4IMi59MV9M0Mi8MaVexvz33lI=;
        b=f4NeHSWXYHXu5WL3dnbDkq0uDS5Me0VpbbBlviqZfghnIGj/BarCRgkPQIZumRT2oF
         JOC2rw458jABxzyICV7zy++GMP6ait5KpPfwxkomsuIO0BDFWTqRrNMZ0XzaVCuda8bB
         HYoSjEdDfex/PyjkjlB6N+f8FMI7B+LqyG7t8Jv0+ISOZvwsSFeB1r5zHI9IgWCZISZp
         KYdwS8phifPpwhmKBoS1zya3JBTQ+LRLqH9HCcGzNE+VsGp93IJy8sqc7vkzYNFfr4b+
         NaISCYrRiotXha0MMc5Sg7MenhBMNGkz6bY8ATF+3rbOOT5lBk+kKT1SR7//xwgHnytH
         SzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769785423; x=1770390223;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=thq0kwrsVjkmoBy4Hq4IMi59MV9M0Mi8MaVexvz33lI=;
        b=mwagT1evhoT9PPkOSlTM1qCilRmj7xNUY0SsSVRHm/N8ZlusKZTYTeQcaEBfJioVVa
         hiZkZ8Ygru1wAhLmDkWJR6Cbm8M5Z6qpmhv6s8l1YYXOvogI+QRsXAETL9DMPjifiyed
         BWvE+/SoKdRDGCQ/nFlmDE2bFFjyoR3IWgOQMLZ+T0QYIZw1k+rRN7ugmSWY1IBj1Fte
         UVz3JqCmi47djWCdLEbjabUUrvDHKtPo4QGpMJzATYz2nEcSwV8mvrNXWR6QZ0saJcCV
         FPO4cUlK3RNIbMfEks7HeMMPJa8xlGqO4IH/Jlr4aEYx97rgYsgzwLYkHBXJE1K5ywry
         DRow==
X-Forwarded-Encrypted: i=1; AJvYcCUaRWBUybwGd9/o+p2ItiXYT5hlDpWb8atVn3vKsYR/XsCyzeJsaxmkvp4fdz/Wp/1xV02Pw8dxDVVwmtU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzut73uwT8IWnq8qqf0PaTPsoeY64ryOjrDBZgJ/TWEQJ5zTi1K
	zebartzU1FeMBs7WHS92W1BDE6s5t7h+5hSPJIki5dzJ0mBg7WMX0psqDoYrN16kWd9OdIv7cDm
	KUPlyr1I=
X-Gm-Gg: AZuq6aJ5OZqK3AJ+/ODnHWgZipgIGHFriclVOzptsBjsS/mMLJzmG0Uk8Wg/8lqXj9f
	Z+KuPFnhSj/VteAX3SBAP3CHHkmZFoGi9JkVQ1udD4SjZ1YC+4QR2/dewdhyGL4LT0zImrL0iNe
	uamli72yPIlvv2ajahhh9SJmKxARcTzpy9wa6BD3FQQRkhwtShK+T4idx4iblLlZGX8KIpVVmt1
	0Vc43AO/ScBO4Pbi/rdMKmLI5ETFqfTVRud8UMEL2ZkZVy7bsNeENQPMlh8LikBC5hVvd5DWVG2
	qo3+oitrJQLpauj2tqTI8qsELZC3zwllwSiY4+4VWZLSU6Dxo51iIffTP5hLoELxFwHzXS7DnER
	9F9MRqDCq8+hVJJG2TNhmQS4l0hv039OsWME+ObvA+dL/L0Ff4FOvYLyMH6ie5dpxtU7BDW4rdw
	F5sVm1z86buOQR22oDSOICCY+0nFLmr+tg9mcmrvEl7HC7oLmyNYSZ3yE9E1Zwq2gDwXY2RiWwL
	oWV39aO3A==
X-Received: by 2002:a05:600c:1c02:b0:480:3ad0:93bf with SMTP id 5b1f17b1804b1-482db494df7mr41910225e9.24.1769785422746;
        Fri, 30 Jan 2026 07:03:42 -0800 (PST)
Received: from ?IPv6:2a02:3030:667:8639:a801:6b4d:7772:893b? ([2a02:3030:667:8639:a801:6b4d:7772:893b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482e2e3bf18sm16546345e9.19.2026.01.30.07.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 07:03:42 -0800 (PST)
Message-ID: <e05ccdce1e82b42e837d104922eec1600cce579d.camel@linaro.org>
Subject: Re: [PATCH 3/3] rtc: optee: simplify OP-TEE context match
From: Rouven Czerwinski <rouven.czerwinski@linaro.org>
To: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>, Sumit Garg
	 <sumit.garg@kernel.org>, Olivia Mackall <olivia@selenic.com>, Herbert Xu
	 <herbert@gondor.apana.org.au>, =?ISO-8859-1?Q?Cl=E9ment_L=E9ger?=
	 <clement.leger@bootlin.com>, op-tee@lists.trustedfirmware.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-rtc@vger.kernel.org
Date: Fri, 30 Jan 2026 16:03:37 +0100
In-Reply-To: <202601291605277bc279f4@mail.local>
References: 
	<20260126-optee-simplify-context-match-v1-0-d4104e526cb6@linaro.org>
	 <20260126-optee-simplify-context-match-v1-3-d4104e526cb6@linaro.org>
	 <202601291605277bc279f4@mail.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGkgQWxleGFuZHJlLAoKT24gVGh1LCAyMDI2LTAxLTI5IGF0IDE3OjA1ICswMTAwLCBBbGV4YW5k
cmUgQmVsbG9uaSB3cm90ZToKPiBPbiAyNi8wMS8yMDI2IDExOjExOjI2KzAxMDAsIFJvdXZlbiBD
emVyd2luc2tpIHZpYSBCNCBSZWxheSB3cm90ZToKPiA+IEZyb206IFJvdXZlbiBDemVyd2luc2tp
IDxyb3V2ZW4uY3plcndpbnNraUBsaW5hcm8ub3JnPgo+ID4gCj4gPiBTaW1wbGlmeSB0aGUgVEVF
IGltcGxlbWVudG9yIElEIG1hdGNoIGJ5IHJldHVybmluZyB0aGUgYm9vbGVhbgo+ID4gZXhwcmVz
c2lvbiBkaXJlY3RseSBpbnN0ZWFkIG9mIGdvaW5nIHRocm91Z2ggYW4gaWYvZWxzZS4KPiA+IAo+
ID4gU2lnbmVkLW9mZi1ieTogUm91dmVuIEN6ZXJ3aW5za2kgPHJvdXZlbi5jemVyd2luc2tpQGxp
bmFyby5vcmc+Cj4gPiAtLS0KPiA+IMKgZHJpdmVycy9ydGMvcnRjLW9wdGVlLmMgfCA1ICstLS0t
Cj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlvbnMoLSkKPiA+
IAo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcnRjL3J0Yy1vcHRlZS5jIGIvZHJpdmVycy9ydGMv
cnRjLW9wdGVlLmMKPiA+IGluZGV4IDE4NGM2ZDE0MjgwMS4uMmYxOGJlM2RlNjg0IDEwMDY0NAo+
ID4gLS0tIGEvZHJpdmVycy9ydGMvcnRjLW9wdGVlLmMKPiA+ICsrKyBiL2RyaXZlcnMvcnRjL3J0
Yy1vcHRlZS5jCj4gPiBAQCAtNTQxLDEwICs1NDEsNyBAQCBzdGF0aWMgaW50IG9wdGVlX3J0Y19y
ZWFkX2luZm8oc3RydWN0IGRldmljZQo+ID4gKmRldiwgc3RydWN0IHJ0Y19kZXZpY2UgKnJ0YywK
PiA+IMKgCj4gPiDCoHN0YXRpYyBpbnQgb3B0ZWVfY3R4X21hdGNoKHN0cnVjdCB0ZWVfaW9jdGxf
dmVyc2lvbl9kYXRhICp2ZXIsCj4gPiBjb25zdCB2b2lkICpkYXRhKQo+ID4gwqB7Cj4gPiAtCWlm
ICh2ZXItPmltcGxfaWQgPT0gVEVFX0lNUExfSURfT1BURUUpCj4gPiAtCQlyZXR1cm4gMTsKPiA+
IC0JZWxzZQo+ID4gLQkJcmV0dXJuIDA7Cj4gPiArCXJldHVybiAodmVyLT5pbXBsX2lkID09IFRF
RV9JTVBMX0lEX09QVEVFKTsKPiAKPiBJIGd1ZXNzIHRoZSBjb3JyZWN0IHdheSB0byBkbyB0aGlz
IHdvdWxkIGJlOgo+IAo+IHJldHVybiAhISh2ZXItPmltcGxfaWQgPT0gVEVFX0lNUExfSURfT1BU
RUUpOwoKQ291bGQgeW91IGV4cGxhaW4gd2h5PyBJZiBJIHJlYWQgdGhlIHN0YW5kYXJkIGNvcnJl
Y3RseSwgYW4gZXF1YWxpdHkKb3BlcmF0aW9uIGFsd2F5cyBwcm9kdWNlcyBlaXRoZXIgMSBvciAw
LCBzbyB0aGVyZSBzaG91bGQgYmUgbm8gbmVlZCBmb3IKISEgaGVyZSBsaWtlIHRoZXJlIGlzIGZv
ciBiaXQgZmxhZyBjb21wYXJpc29ucywgaS5lLiAhIShmbGFnICYKU09NRV9GTEFHX1NFVCkgdG8g
bm9ybWFsaXplIHRvIDEgb3IgMC4gV29uZGVyaW5nIGlmIEkgYW0gbWlzc2luZwpzb21ldGhpbmcu
Cgo+IEJ1dCBpcyB0aGlzIGNoYW5nZSBhY3R1YWxseSBnZW5lcmF0aW5nIGJldHRlciBjb2RlPwo+
IAo+IEJlZm9yZToKPiAKPiBzdGF0aWMgaW50IG9wdGVlX2N0eF9tYXRjaChzdHJ1Y3QgdGVlX2lv
Y3RsX3ZlcnNpb25fZGF0YSAqdmVyLCBjb25zdAo+IHZvaWQgKmRhdGEpCj4gewo+IMKgwqDCoMKg
wqDCoMKgIGlmICh2ZXItPmltcGxfaWQgPT0gVEVFX0lNUExfSURfT1BURUUpCj4gwqDCoMKgwqDC
oMKgIDA6wqDCoMKgwqDCoMKgIGU1OTAwMDAwwqDCoMKgwqDCoMKgwqAgbGRywqDCoMKgwqAgcjAs
IFtyMF0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDE7Cj4gwqDCoMKg
wqDCoMKgwqAgZWxzZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsK
PiB9Cj4gwqDCoMKgwqDCoMKgIDQ6wqDCoMKgwqDCoMKgIGUyNDAwMDAxwqDCoMKgwqDCoMKgwqAg
c3ViwqDCoMKgwqAgcjAsIHIwLCAjMQo+IMKgwqDCoMKgwqDCoCA4OsKgwqDCoMKgwqDCoCBlMTZm
MGYxMMKgwqDCoMKgwqDCoMKgIGNsesKgwqDCoMKgIHIwLCByMAo+IMKgwqDCoMKgwqDCoCBjOsKg
wqDCoMKgwqDCoCBlMWEwMDJhMMKgwqDCoMKgwqDCoMKgIGxzcsKgwqDCoMKgIHIwLCByMCwgIzUK
PiDCoMKgwqDCoMKgIDEwOsKgwqDCoMKgwqDCoCBlMTJmZmYxZcKgwqDCoMKgwqDCoMKgIGJ4wqDC
oMKgwqDCoCBscgo+IAo+IEFmdGVyOgo+IAo+IHN0YXRpYyBpbnQgb3B0ZWVfY3R4X21hdGNoKHN0
cnVjdCB0ZWVfaW9jdGxfdmVyc2lvbl9kYXRhICp2ZXIsIGNvbnN0Cj4gdm9pZCAqZGF0YSkKPiB7
Cj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuICEhKHZlci0+aW1wbF9pZCA9PSBURUVfSU1QTF9JRF9P
UFRFRSk7Cj4gwqDCoMKgwqDCoMKgIDA6wqDCoMKgwqDCoMKgIGU1OTAwMDAwwqDCoMKgwqDCoMKg
wqAgbGRywqDCoMKgwqAgcjAsIFtyMF0KPiB9Cj4gwqDCoMKgwqDCoMKgIDQ6wqDCoMKgwqDCoMKg
IGUyNDAwMDAxwqDCoMKgwqDCoMKgwqAgc3ViwqDCoMKgwqAgcjAsIHIwLCAjMQo+IMKgwqDCoMKg
wqDCoCA4OsKgwqDCoMKgwqDCoCBlMTZmMGYxMMKgwqDCoMKgwqDCoMKgIGNsesKgwqDCoMKgIHIw
LCByMAo+IMKgwqDCoMKgwqDCoCBjOsKgwqDCoMKgwqDCoCBlMWEwMDJhMMKgwqDCoMKgwqDCoMKg
IGxzcsKgwqDCoMKgIHIwLCByMCwgIzUKPiDCoMKgwqDCoMKgIDEwOsKgwqDCoMKgwqDCoCBlMTJm
ZmYxZcKgwqDCoMKgwqDCoMKgIGJ4wqDCoMKgwqDCoCBscgo+IAo+IEknbSBpbiBmYXZvciBvZiBr
ZWVwaW5nIHRoZSBjdXJyZW50IHZlcnNpb24uCgpJIGxpa2UgdGhlIHNob3J0IHZlcnNpb24gYmV0
dGVyLCBidXQgSSBhbSBhbHNvIG5vdCB2ZXJ5IGF0dGFjaGVkIHRvCmdldHRpbmcgdGhpcyBpbiBh
dCBhbGwsIEknbGwgbGV0IHRoZSBtYWludGFpbmVycyBkZWNpZGUuCgpUaGFua3MgYW5kIGJlc3Qg
cmVnYXJkcywKUm91dmVuCgoK

