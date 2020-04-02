Return-Path: <SRS0=UIra=5S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C883CC43331
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 15:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F0AE206F6
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 15:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="hIzMlAza"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389198AbgDBPfs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:35:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42773 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732970AbgDBPfr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Apr 2020 11:35:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15so4729688wrx.9
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2020 08:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:autocrypt:organization:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n0G8PgKT6N4LycPsn3YPbg8CmY7AYCMmAC0zQVOGL0M=;
        b=hIzMlAzaySo3rTxfU67BAMFqDRt8Q6tAsfuKShRe0AA1rwasEPYNcL+NCR+UYLfLCn
         dhAv7a9Q56lSxPJLPSCHKICJJUPPqnlrxuYNZjgl7hOAsqhFnEsxNFT146zv5euKKcCO
         ySZ9Rsl+5MkjTLJto8AnE0NrTgRG1uuzufERGffV/1FnFG8ALwCQimgaNuZHaCQiG2Ky
         q8TwXSQIr6k1zeZrUsP0u4vBXk71ONKKciGQtnO5+Ud3JU6IBcCUGGi54qH/bA1hMxbW
         uCKvDVwSEgRfZBze2NLpE/Z+krqKCWhN3yBNhfDNG5AXLny4k9NfHL5yx3qeMOPZKkql
         QMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=n0G8PgKT6N4LycPsn3YPbg8CmY7AYCMmAC0zQVOGL0M=;
        b=YOc9bUA4+W7KjkRRgb8tq7IClfBnosfBc9hxbjHl9ng/diR0DBc7zt3jjOg90b782s
         Z1IImXBjmcToafcKJriBL12W4mSDvmviVq4NS2icF6C3MOykicUMjDfCMgfo0CkA+fw0
         IXpmCfZR9RgvpN08Ms5dLRzABHcGEVAc2jFI7Dzwl02Jx8b0+Z8RRxZXLZ+GMB+3LYdP
         gEOuYdKvJT4u6SGIUGxVoCO3a96263bFWQTCZuvtIkQF7CmZlnXCintUWAb2OXryh7RX
         br9ZSbl0PDbAdQXbhd7FCsizC+I3/MHkbTO5lE6jYFmBoS+Lg1YRJKaAJz9WFxzye3ZR
         oYJQ==
X-Gm-Message-State: AGi0PuYjQiwd2giJSR48awWw+VOlJHOfS9KxK9KcF/R/LdKXsxyI1SPR
        aP6+pHhE7bp1mm6FiopD8T7+zw==
X-Google-Smtp-Source: APiQypJ1XGUq/Qik2b9mDHCOvXzdSe550uTteLiXSgdV9eZoITWe9rl43BG//I3FD2EzT9gwi6PZlA==
X-Received: by 2002:adf:bb06:: with SMTP id r6mr4194796wrg.324.1585841744387;
        Thu, 02 Apr 2020 08:35:44 -0700 (PDT)
Received: from ?IPv6:2a01:e35:2ec0:82b0:5c5f:613e:f775:b6a2? ([2a01:e35:2ec0:82b0:5c5f:613e:f775:b6a2])
        by smtp.gmail.com with ESMTPSA id c18sm7853918wrx.5.2020.04.02.08.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 08:35:43 -0700 (PDT)
Subject: Re: [PATCH] crypto:amlogic - use platform_get_irq_optional()
To:     "tangbin@cmss.chinamobile.com" <tangbin@cmss.chinamobile.com>,
        clabbe <clabbe@baylibre.com>,
        herbert <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>
Cc:     linux-amlogic <linux-amlogic@lists.infradead.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200402113344.16772-1-tangbin@cmss.chinamobile.com>
 <c43b85f8-2bc9-7b19-6b86-953246c88d2c@baylibre.com>
 <202004022329105659148@cmss.chinamobile.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 BSwxi7g3Mu7u5kUByanqHyA=
Organization: Baylibre
Message-ID: <f4cb309e-a873-5529-5be2-6992f7d89a96@baylibre.com>
Date:   Thu, 2 Apr 2020 17:35:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <202004022329105659148@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGksDQoNCk9uIDAyLzA0LzIwMjAgMTc6MjksIHRhbmdiaW5AY21zcy5jaGluYW1vYmlsZS5j
b20gd3JvdGU6DQo+IERlYXIgTmVpbO+8mg0KPiDCoCDCoCDCoCDCoCBUaGFuayB5b3UgZm9y
IHlvdXIgcmVwbGF577yMbWF5YmUgbXkgZGVzY3JpcHRpb24gaXMgbm90IHNvIGNsZWFy44CC
V2hhdCBJIHdhbnQgdG8gc2F5IGlz77yaSW4gdGhpcyBwbGFjZSwgd2hlbiBzb21ldGhpbmcg
Z29lcyB3cm9uZywgcGxhdGZvcm1fZ2V0X2lycSgpIHdpbGwgcHJpbnQgYW4gZXJyb3IgbWVz
c2FnZSwgYW5kIHRoaXMgZnVuY3Rpb24gd2lsbCBwcmludCBib3Ro77yMc28gaWYgd2Ugd2Fu
dCB0byBhdm9pZCB0aGUgc2l0dWF0aW9uIG9mIHJlcGVhdCBvdXRwdXTvvIx3ZSBjYW4gcmVt
b3ZlIGRldl9lcnIoKSBoZXJlIG9yIHVzZSBwbGF0Zm9ybV9nZXRfaXJxX29wdGlvbmFsKCkg
wqBpbnN0ZWFkIG9mIHBsYXRmb3JtX2dldF9pcnEoKeOAglRoYW5rIHlvdSB2ZXJ5IG11Y2jj
gIINCg0KUGxlYXNlIGRvIG5vdCB0b3AtcG9zdC4NCg0KU2luY2UgdGhlIGlycSBpcyBub3Qg
b3B0aW9uYWwsIHJlbW92aW5nIHRoZSBkZXZfZXJyKCkgaXMgdGhlIHJpZ2h0IHdheSB0byBn
by4NCg0KTmVpbA0KDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+ICAgICDCoA0K
PiAgICAgKkZyb206KsKgTmVpbCBBcm1zdHJvbmcgPG1haWx0bzpuYXJtc3Ryb25nQGJheWxp
YnJlLmNvbT4NCj4gICAgICpEYXRlOirCoDIwMjAtMDQtMDLCoDIxOjI2DQo+ICAgICAqVG86
KsKgVGFuZyBCaW4gPG1haWx0bzp0YW5nYmluQGNtc3MuY2hpbmFtb2JpbGUuY29tPjsgY2xh
YmJlIDxtYWlsdG86Y2xhYmJlQGJheWxpYnJlLmNvbT47IGhlcmJlcnQgPG1haWx0bzpoZXJi
ZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBkYXZlbSA8bWFpbHRvOmRhdmVtQGRhdmVtbG9m
dC5uZXQ+DQo+ICAgICAqQ0M6KsKgbGludXgtYW1sb2dpYyA8bWFpbHRvOmxpbnV4LWFtbG9n
aWNAbGlzdHMuaW5mcmFkZWFkLm9yZz47IGxpbnV4LWNyeXB0byA8bWFpbHRvOmxpbnV4LWNy
eXB0b0B2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWwgPG1haWx0bzpsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnPg0KPiAgICAgKlN1YmplY3Q6KsKgUmU6IFtQQVRDSF0gY3J5
cHRvOmFtbG9naWMgLSB1c2UgcGxhdGZvcm1fZ2V0X2lycV9vcHRpb25hbCgpDQo+ICAgICBI
aSwNCj4gICAgIMKgDQo+ICAgICBPbiAwMi8wNC8yMDIwIDEzOjMzLCBUYW5nIEJpbiB3cm90
ZToNCj4gICAgID4gSW4gb3JkZXIgdG8gc2ltcGx5IGNvZGUsYmVjYXVzZSBwbGF0Zm9ybV9n
ZXRfaXJxKCkgYWxyZWFkeSBoYXMNCj4gICAgID4gZGV2X2VycigpIG1lc3NhZ2UuDQo+ICAg
ICA+DQo+ICAgICA+IFNpZ25lZC1vZmYtYnk6IFRhbmcgQmluIDx0YW5nYmluQGNtc3MuY2hp
bmFtb2JpbGUuY29tPg0KPiAgICAgPiAtLS0NCj4gICAgID7CoCBkcml2ZXJzL2NyeXB0by9h
bWxvZ2ljL2FtbG9naWMtZ3hsLWNvcmUuYyB8IDIgKy0NCj4gICAgID7CoCAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gICAgID4NCj4gICAgID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2FtbG9naWMvYW1sb2dpYy1neGwtY29yZS5j
IGIvZHJpdmVycy9jcnlwdG8vYW1sb2dpYy9hbWxvZ2ljLWd4bC1jb3JlLmMNCj4gICAgID4g
aW5kZXggOWQ0ZWFkMmY3Li4zNzkwMWJkODEgMTAwNjQ0DQo+ICAgICA+IC0tLSBhL2RyaXZl
cnMvY3J5cHRvL2FtbG9naWMvYW1sb2dpYy1neGwtY29yZS5jDQo+ICAgICA+ICsrKyBiL2Ry
aXZlcnMvY3J5cHRvL2FtbG9naWMvYW1sb2dpYy1neGwtY29yZS5jDQo+ICAgICA+IEBAIC0y
NTIsNyArMjUyLDcgQEAgc3RhdGljIGludCBtZXNvbl9jcnlwdG9fcHJvYmUoc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqcGRldikNCj4gICAgID7CoA0KPiAgICAgPsKgIG1jLT5pcnFzID0g
ZGV2bV9rY2FsbG9jKG1jLT5kZXYsIE1BWEZMT1csIHNpemVvZihpbnQpLCBHRlBfS0VSTkVM
KTsNCj4gICAgID7CoCBmb3IgKGkgPSAwOyBpIDwgTUFYRkxPVzsgaSsrKSB7DQo+ICAgICA+
IC0gbWMtPmlycXNbaV0gPSBwbGF0Zm9ybV9nZXRfaXJxKHBkZXYsIGkpOw0KPiAgICAgPiAr
IG1jLT5pcnFzW2ldID0gcGxhdGZvcm1fZ2V0X2lycV9vcHRpb25hbChwZGV2LCBpKTsNCj4g
ICAgID7CoCBpZiAobWMtPmlycXNbaV0gPCAwKSB7DQo+ICAgICA+wqAgZGV2X2VycihtYy0+
ZGV2LCAiQ2Fubm90IGdldCBJUlEgZm9yIGZsb3cgJWRcbiIsIGkpOw0KPiAgICAgPsKgIHJl
dHVybiBtYy0+aXJxc1tpXTsNCj4gICAgID4NCj4gICAgIMKgDQo+ICAgICBOQUNLLCB0aGUg
aXJxIGlzIG5vdCBvcHRpb25hbCwgSSBkb24ndCBzZWUgd2h5IHBsYXRmb3JtX2dldF9pcnFf
b3B0aW9uYWwoKSBzaG91bGQgYmUgdXNlZCBoZXJlDQo+ICAgICBhbmQgaG93IGl0IGNvdWxk
ICJzaW1wbHkgY29kZSIuDQo+ICAgICDCoA0KPiAgICAgTmVpbA0KPiANCg0K
