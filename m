Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BD73F6C58
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787771820; cv=none; b=O92QjZvWdTLFpSkB4nCRngq/MJEq4Xw8pBNL0+SDD2nMieAljBWRoyOUwBrnldbaioMSuTU4UTTr6zQwT+v5IhagibaDuAYJ9gKdYidrIHo3gH/BhvubtKAmGSBym3Ct8KvieUvI/cWd9yc0e3n4nns7dK0BlROeEir6kenSkt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787771820; c=relaxed/simple;
	bh=EhZOmsiLTyAPqeWEbBa0NSn+Bs2IPQLepUO00ZQjj9c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YaygT9CnhnvubwLI4h3+vDF+1ES8rVMXRMfdnkyFS+OuvZfUyzP8t+ub7FxSPJvALjePrS7iFzQ2ZlU0EDpWXY9oqkUPwEz9lIf49+rW6MOh8QS7mxJsBZBxQEOdO8AD3pbZ65a+kdeANPoyCNYt8bIKteItYvYNPncFPPU/mD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=eventprospectdata.com; spf=pass smtp.mailfrom=eventprospectdata.com; dkim=pass (2048-bit key) header.d=eventprospectdata-com.20251104.gappssmtp.com header.i=@eventprospectdata-com.20251104.gappssmtp.com header.b=dn/Adxdk; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=eventprospectdata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eventprospectdata.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=eventprospectdata-com.20251104.gappssmtp.com header.i=@eventprospectdata-com.20251104.gappssmtp.com header.b="dn/Adxdk"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1cf287ef8so515929a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eventprospectdata-com.20251104.gappssmtp.com; s=20251104; t=1787771810; x=1788376610; darn=vger.kernel.org;
        h=disposition-notification-to:content-language:thread-index
         :content-type:mime-version:message-id:date:subject:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=aE8fiUo6jvo0Kwtq98EujPEP396oeKdnipp6R0GUto8=;
        b=dn/AdxdkUF3SmIgVUBtvZ5XoBIkc5s+CP11YQ0RPnEIZd6tBTe0CMSwtJ9vkKUSax9
         uvM4b6/SfakrKmSyxRsfTDUmufd75P4NfC6kv/k7Iu5qeQDjw5E5NKS5cgVa7DukQTwV
         CyTZbe2CONceCw0CUu/uJdiT3ZP0NG57Dc0lczDZwFdqmlQm+8VYbI7AZfTZ6i+5xBG/
         iFOuBSrV9u1qZn15dAdgPdEEZKnBIo+aokPRpbsoZYyyWnNy6FV+AdmY3PAginZny8NX
         e8BW6J7RXkg8iPv1rn9SWO8vFt38dB2aTKkN0rN3l3tnCIcy3dzPb9m13XVQ8tAnyyWS
         Uf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787771810; x=1788376610;
        h=disposition-notification-to:content-language:thread-index
         :content-type:mime-version:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aE8fiUo6jvo0Kwtq98EujPEP396oeKdnipp6R0GUto8=;
        b=V2Pr7poTGn2xGVSARsycTOcAZgwf6BM1qcvzg2Sgmqm0exHW+KPeEKTdqDewqV+c6j
         Drg0uXZ3WKSQfHA6vTaM5dXdlxwGtysJTLCKVpnJLxzkG5MsvhqtKnnfQVRhZHCzAVc4
         TaN0wKhGGB/Fzpg3OSRs1ipDRY82wqsD3IUZsoWzLz9ek8svFP/R1LRBML9G+zWwVfWL
         FhzuMSDpZvFL1+NMPFduGmDN+WHefzSnZhk4+ler5npHRKYueEzW1tTtldJ1m3YI8Etk
         Wp+cdCBOLo2In0dXhtTAgltqZ7+X3xZa4OIr9D/yzpQz198MxJgKrheexcbe6RyeNpOW
         dMlw==
X-Gm-Message-State: AFuF++me4Ml5DwWG3ccTZ5YsDj2NqxvlNaEFRnuNMD4bUonA3oJB2uHN
	d3Q/JbBiZuq7J1+vCfg8h3+uRSrAI+CLbLOy3v7ze+p843gDEOz5jZoigRaeloNJ30/t36b2dgo
	eA4CC
X-Gm-Gg: AR+sD13Hhfx7EwaynVcEQhOflHYBM6vXERubKhIaJu1yAJ8YQ3ahjyxZklTVJ2x9YOj
	/BRXa0qlkujK575Q2izP+63JaOiSd+z9fN2IZ6t3u4n6nSABcn58qFVBcSlEXkSkAthYRBbb6Ed
	AxiyUV+SluVPrJS7QCQQK09CQLXvrsVSv1cAQnuCkRLOQv50HMqngDO383ZnrkaHceSuTubLHPq
	fWyh3piCRSPW68z880nWMjrJUAt2GODiTF7N4zzV0kN9XBW0o5klpPJJY23gY0W9R4vCDv/9Ncp
	0JikOfv1x0q10zRANexD1626LUrAqSWK3ajTqVUVXSCWs8cusz9+S/xFSZi7GFuneyUAI97HuDf
	tBwntkVoc3TH69ZNdiyYD2TBqKyg1ZJZR2hj6tRjSs5eGayEo1+euNmREibt5o/0k96+nfc8ISk
	3bFagpbkasvQpyrbd7b0eJXQhrh3PtrLWYiIpsnKqMKAUXGtlLbKkMKDoinlAeToyd6p+c8Oyvx
	MB+5L5CB5ObF8c=
X-Received: by 2002:a17:90b:1804:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-3966d400328mr17727657a91.10.1787771810059;
        Wed, 26 Aug 2026 12:16:50 -0700 (PDT)
Received: from DESKTOPKFKOC8H ([2406:7400:11d:a556:f10e:6485:6459:9d71])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d8d208csm10656459eec.23.2026.08.26.12.16.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2026 12:16:48 -0700 (PDT)
From: "Monica Arellano" <monica.a@eventprospectdata.com>
To: <linux-crypto@vger.kernel.org>
Subject: Tech Show Madrid 2026 - Vger.Kernel
Date: Wed, 26 Aug 2026 16:16:43 -0300
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAPk5ouWl8q9IoAKtFEFS7BHCgAAAGAAAAAAAAAD5OaLlpfKvSKACrRRBUuwRZEeyAAEAAAAA@eventprospectdata.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_787B_01DD3576.4B3C9EE0"
X-Mailer: Microsoft Outlook 16.0
Thread-Index: Ad01j24tPyOCbXTaQQmgsP2G8rgLBA==
Content-Language: en-us
X-MS-TNEF-Correlator: 00000000F939A2E5A5F2AF48A002AD144152EC118447B200

This is a multipart message in MIME format.

------=_NextPart_000_787B_01DD3576.4B3C9EE0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

 

Would you be interested in acquiring the attendees email database for Tech
Show Madrid 2026?

 

Attendee Profiles: IT Directors, CIOs, CTOs, Cloud & Infrastructure
Managers, Cybersecurity Professionals, Data & Analytics Leaders, Digital
Transformation Managers, Network Administrators, IT Operations Managers,
Software & Technology Professionals, System Architects, DevOps
Professionals, and more!

 

Please let me know if you're interested, and we can provide you with the
total number of attendees and pricing details for your review.

 

Best regards,

Monica Arellano

Trade Show & Events Data Specialist

 

Note: If you're also interested in upcoming event lists or industry
email/user lists, please feel free to let me know. I'd be happy to help you
find the right data for your needs.


------=_NextPart_000_787B_01DD3576.4B3C9EE0
Content-Type: application/ms-tnef;
	name="winmail.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="winmail.dat"

eJ8+Ii8TAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEIgAcAGAAAAElQTS5NaWNy
b3NvZnQgTWFpbC5Ob3RlADEIAQOQBgCMDgAAKQAAAAsAAgABAAAAAwAmAAAAAAALACkAAQAAAAIB
MQABAAAAVgAAAFBDREZFQjA5AAEAAgAAAAAAAAAAAAAAAAAYAAAAAAAAAPk5ouWl8q9IoAKtFEFS
7BHCgAAAGAAAAAAAAAD5OaLlpfKvSKACrRRBUuwRZEeyAAEAAAAAAAAeAHAAAQAAACQAAABUZWNo
IFNob3cgTWFkcmlkIDIwMjYgLSBWZ2VyLktlcm5lbAACAXEAAQAAABYAAAAB3TWPbi0/I4JtdNpB
CaCw/YbyuAsEAAALAAEOAAAAAAIBCg4BAAAAGAAAAAAAAAD5OaLlpfKvSKACrRRBUuwRwoAAAAMA
FA4BAAAAHgAoDgEAAABHAAAAMDAwMDAwMDgBbW9uaWNhLmFAZXZlbnRwcm9zcGVjdGRhdGEuY29t
AW1vbmljYS5hQGV2ZW50cHJvc3BlY3RkYXRhLmNvbQAAHgApDgEAAABHAAAAMDAwMDAwMDgBbW9u
aWNhLmFAZXZlbnRwcm9zcGVjdGRhdGEuY29tAW1vbmljYS5hQGV2ZW50cHJvc3BlY3RkYXRhLmNv
bQAAAwAWEAAAAAADAN4/n04AAAMA8T8JBAAAAwACWQAAFgADAAlZAgAAAAMAEIAIIAYAAAAAAMAA
AAAAAABGAAAAABCFAAAAAAAACwAcgAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAAAAADACKACCAG
AAAAAADAAAAAAAAARgAAAAABhQAAAAAAAAsAeIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAA
CwB6gAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAH2ACCAGAAAAAADAAAAAAAAARgAAAAAY
hQAAAAAAAAsAkoAIIAYAAAAAAMAAAAAAAABGAAAAAIKFAAABAAAAHgDOgAggBgAAAAAAwAAAAAAA
AEYBAAAAGAAAAEMAbwBtAHAAbwBzAGUAVAB5AHAAZQAAAAEAAAAIAAAAbmV3TWFpbAADANCACCAG
AAAAAADAAAAAAAAARgAAAADrhQAACQQAAAIB2YAIIAYAAAAAAMAAAAAAAABGAQAAADYAAABJAG4A
VAByAGEAbgBzAGkAdABNAGUAcwBzAGEAZwBlAEMAbwByAHIAZQBsAGEAdABvAHIAAAAAAAEAAAAQ
AAAAupOM00Lu1EKmhYZfYMapWAUACoEpAwIAAAAAAMAAAAAAAABGAQAAABAAAABFAE0ATQBNAG8A
dgBlAAAAAAAAAAAA8D8LAB8OAQAAAAIB+A8BAAAAEAAAAPk5ouWl8q9IoAKtFEFS7BECAfoPAQAA
ABAAAAD5OaLlpfKvSKACrRRBUuwRAwD+DwUAAAACAQkQAQAAAHwJAAB4CQAADh8AAExaRnU5pvsX
AwAKAHJjcGcxMjWCMgNDaHRtbDEDMfhiaWQEAAMwAQMB9wqA/wKkA+QHEwKAEIMAUARWCFWfB7IR
tQ5RAwECAGNoCsBwc2V0MgYABsMRtTPbBEYURzASvwIANAPFFlmkIkMHQGliBRAiAoDXEcMI7wn3
OxrSNwmlDiCxChQxMzQRsgxgYwBQMwsJAWQzNhbgC6U0IDkQgipcDrIBkA4QOSAyPA6yIHgO0ACA
OnYkPSIIcG46BPBoZTEAwHMtbQ3gA2Bzb7UBgC0FoG0hkA7QIiE1rm8hvyLJIvBmDeBlJeW9I6Z3
JD8lTycwBbBkI6YGbSdQDrB0cDovL1UntS4ily4jMS8l9C+xAdAwNC8OICwwbSOHhSpXdy5wLncz
LgWwAGcvVFIvUkVDwi0OsjQwIj4RwyAnIx1QINFlYWQwDTE2jQ7wPAeAAZAgbmEHgMw9RwnwBJBh
dAWxBaArAjAJ8HQnUE0ipiBXwSmRIDE1ICgmECBwGwSQCYAgB4APUHVtKQcv/h+wMoFzdHlsZSM2
zzKBIS0tCqMvKmQgRgIhIEQBEAuAaUx0aQIgBCAqLwqjQOkCEi1mANBlCqQBkQMwxns71SKQbHk6
GVEG0HcHIQXQM6BoGdA8aAqwbuEi0GUtMToU0B/ANYB2M0AxH8A2QFFAARvwff87fzyPPZMZZT7P
P9M1cTWAvxTQRfIfwEDvQf89G0EFMHci0EbGOhFTOBI6jwrBcDQuTSLgTgWwAMBsLO4gGYBMCg9Q
dkwIR+oAwPMu8AuAOjALgERJR1MAkOZ6JkAOIC4wBTBP3j128UljIixzAHFQwAZyREnqbSLgLRmA
ZzOgCHAHkLMnoAGQbmQLETPzeFVAyxGRRtVzP3EuRQDAAxC5SmMxN057VNE4Ay04EH5wJkBZ0BSQ
AiAHQCMicP8/oVGPUp9TrzPhGnEnMAuAOGRvd1ZSRsZMAkNo8nBKwWF1IHBYX1loVmB7WsAAIC0C
ID2wRscKsGf3SqA1IgZgYzryHeNIJlDT2DguNQuANWAxUUBPu/9PNWYjNWBnrkbGTaJj70g1/WOS
OmnKRsY5oDhfIMEq0Ms4HzkoWwaQIGc0IFSyoCA5XT48IUE+CqP8PG8noBRwWdABAWBiBCDudmJB
NFE2UXQjoFdAD0CFAMB4J1AxMDI2I6DaL3E1L3ECOYBbCfAPUHxmXWzfb49wn3GlC2B53whgBUBy
qnE3c5JwcpxV4P8BkHPhdEl4+3gwdO8wHDfCVi8xPyCQNRbgPAbgZAZ5TLAAcGc9RU4tJlUF8BmA
bmsnUCM0UDY3ODh0MXaDFTkyNh8gN0RzUW5SPSd5KYItdzOQKqAZoICwa/uFsCmRJzAAIDMAIQMw
gmL9dAAzQGCG5hbgH+uEgCDQ702hM+ALYAQQPWnKhskAAPuILyBjNjEBe2CKBEwXiy/zjD8OEDQ4
N+E/cYT2PS0fGYRc6Ya6F/KICUhpLPd2DTEBcaBwde4OQH1Dlw7/NXCJkSrQP3GGyYbXHzGG9f8K
oprYCoGG9wqxnOiInQHA/24Rlw6NX45vng+Qj5Gfkq9fk7+Uy5XPlt8gkDgfwCacbmJXQAKAhugn
YQFA/6hvl7+Yz5nfmu+b/50PrM//ny+gP6FPol+jb6R/pY+mnz+nr7kyNSBgcDVQeYEgYn9KoAuA
NeJuQDYRZeEA0HHsdWkFEIKAID6QSqAzoL80IQEAB5En4QMRfFJiKAD/SqACEAXAqm6CALgbPOG4
52pUBZBoBgBoXuA+YWT/BRA1UAHQdCCIvK4yxHqw6f4/qP+qD63/rw+wH7Evsj//s0+5L7Vvtn+3
j7ifua+6v/+7z7zfve+o78sPqw+sH60v/8xvzX/Oj8+f0K/Rv9LP09//1O/V/+hPw9/E79eP2J/Z
r5fav9vP8ARBwaUgUANg/zWxB5DjD+Qf5SnHb8h/+W8f8Q/yH/Mv9D/vuTogSV5USrDA8GoRwzBz
TKBDtElPAsJUAxMacHU1ULferzMQ3+om+8gCAG4OcPkoAHRyHcBVQsahMwBjsO0Cs3m/oBSRYxLh
blD2c+/CAA3QWkICwUR8YQQPBR9VBihBWlF5OvBjwhBMv4CxCAMCQE9gwrDCcFQzkL//wMMhwkA6
8gepE0B0KYH+a/Xgc6A6wQcRM6ICwQIRXk9aAQ9jwhAHuFMi8Xf/SABKoAp/C48GN8YSP5AacFJn
CR9TecAxbfXgcs8nwDrga+EJ8mV2EhDCEM8JPVXBNjDDMGUh3T/eT//iP/dP+F/lb+Z/54/8H+mv
/+q/68/s3/yf/a/+v//PAN//3S8cb99P4F/hbx3PHt8f7/8g/yIPIx8kLyU/Jk8nXzmv3yl/Ko8r
nyyvLbxQbnDC4utucHmwbUqgaxbgxpB3YeO/YTAPIzgyWDAxW/qgrz54B4G/2Bq0dweQY0BR+nAJ
QHZ7IAeQv2JeoMFQR8FDApAOkm51bQhxIP8TcMGJGtJKwA2AwRIN8MKwf8JgwhDDIr9hYNBVYErw
Zfx3Li6fL68znzSvNb82z/833zjvPs87DzwfPS8+Pz9P/0BfQW9Cf0OPLo9Q/zCvMb//Ms9SX1Nv
VH9Vj1afV69Yv/9Zz1rfW+9uP+4v7z9df16Pb1+fYK9hv3X0QsAhSRFn/ROwZALAaP9qD/u/+j9+
b/92T3dfeG95f3qPgc9j72ff/2jvfb9rD2wfbS+HD29PcF//cW9yf4H/gw+EH4Uvhj+U5J5ND5AN
gApQGLBlbJMA/xbgh6+Iv4nPit+L74z/jg//jx+U/5E/kk+TX5RvlX+Wj/+Xn5ivmb8OwksRxmNk
nxUPuQY3RXb2IBkwChRTEiD/TiCsIcAwm8+c353vnv+gD/+hH6Ivoz+pH6Vfpm+nf6iP/6mfqq+r
v6zPrd+Hn7S/ZT//Zk9nX7Yfty+4P7lPul+7b/+8f72Pvp+/r9H/wc/C38Pv/8T/xgzVoBkAAfFF
70b/SA8bSRIJ0W9JSUlBIHVw/GNvEQFOUBmAsnFFABEx507QTwFOMGR1BxEXMBiAvU6hL+OwTLHi
8wLQcES0vwlgm2BO4EmQS/JFCi4CAB/dv97PSFsa8EygIGhh3HBwFzDmQUvgbNTwS0Lv9rAa4UvS
COBnsRBOYAoy/U73bvZQfIBP78fvy9/M73/N/88P0B/RL9cP00/X1TBh7tEvZGl28k/2b2dGNdhR
gJBvZHnvPjcXgHGxEtPAff3QAwANNP0/pQ4DAA80/T+lDgIBFDQBAAAAEAAAAE5JVEH5v7gBAKoA
N9luAAACAX8AAQAAADEAAAAwMDAwMDAwMEY5MzlBMkU1QTVGMkFGNDhBMDAyQUQxNDQxNTJFQzEx
ODQ0N0IyMDAAAAAAAwAGEESZ9ioDAAcQkQIAAAMAEBAAAAAAAwAREAEAAAAeAAgQAQAAAGUAAABI
SSxXT1VMRFlPVUJFSU5URVJFU1RFRElOQUNRVUlSSU5HVEhFQVRURU5ERUVTRU1BSUxEQVRBQkFT
RUZPUlRFQ0hTSE9XTUFEUklEMjAyNj9BVFRFTkRFRVBST0ZJTEVTOklUAAAAAD/w

------=_NextPart_000_787B_01DD3576.4B3C9EE0--

