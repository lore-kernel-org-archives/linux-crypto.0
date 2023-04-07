Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0958C6FD1D
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Apr 2023 19:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDGThM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Apr 2023 15:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDGThJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2023 15:37:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4645E5B81
        for <linux-crypto@vger.kernel.org>; Fri,  7 Apr 2023 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680896226; x=1712432226;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vVqk4wrE+WzCpq0bGRG7VYPj6MHANHb13tM6sCBNdp0=;
  b=eYDFaRxxcDbZoljXT2IsTFy0SXWZIui7UzZgJdxm7UL7eBAlikXhakn/
   FQYCW/EO4oUih1rVaSrtDCLj/WECThydNb0k8BhipNhaaSggZIB7spgOQ
   PC6tGr+rMpSX1mg6NM48An/UEBOsIFsuzYlVggmNaD2UxxB+X3L0nXrJY
   2vWVIAKxY8VKQ4RHtmDZyCbXgG9b2acLm47ema2ynHzO8ilYsLSpxaEqR
   mfiXBVuJnwy2CBZobmSwJ1omjCLFKJuvEGZT9B7Smz5RhCB/g8zyqOMwT
   XZTvC+CMll6dpic+nGcLbDmKM/xXcne3NOMYRfHf5OFRgLIjyPVwsJ3zJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="343062040"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="343062040"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 12:37:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="687610815"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="687610815"
Received: from tcolquit-mobl.amr.corp.intel.com (HELO bjcleere-mobl2.amr.corp.intel.com) ([10.212.83.122])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 12:37:04 -0700
Message-ID: <ea6af9d99b6c2ff70ca127e4bb6784e6c3032838.camel@linux.intel.com>
Subject: Re: [herbert-cryptodev-2.6:master 99/105]
 include/linux/compiler_types.h:397:45: error: call to
 '__compiletime_assert_385' declared with attribute error: BUILD_BUG_ON
 failed: sizeof(struct crypt_ctl) != 64
From:   Tom Zanussi <tom.zanussi@linux.intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 07 Apr 2023 14:37:03 -0500
In-Reply-To: <202304061846.G6cpPXiQ-lkp@intel.com>
References: <202304061846.G6cpPXiQ-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVGh1LCAyMDIzLTA0LTA2IGF0IDE4OjI4ICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToKPiB0cmVlOsKgwqAKPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9oZXJiZXJ0L2NyeXB0b2Rldi0yLjYuZ2l0Cj4gwqBtYXN0ZXIKPiBoZWFkOsKgwqAg
YTIyMTZlMTg3NDcxNWE4YjRhNmY0ZGEyZGRiZTkyNzdlNTYxM2M0OQo+IGNvbW1pdDogMWJjN2Zk
YmYyNjc3Y2MxODY2YzAyNWU1YTM5MzgxMWVhOGUyNTQ4NiBbOTkvMTA1XSBjcnlwdG86Cj4gaXhw
NHh4IC0gTW92ZSBkcml2ZXIgdG8gZHJpdmVycy9jcnlwdG8vaW50ZWwvaXhwNHh4Cj4gY29uZmln
OiByaXNjdi1hbGxtb2Rjb25maWcKPiAoaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9h
cmNoaXZlLzIwMjMwNDA2LzIwMjMwNDA2MTg0Ni5HNmNwUFgKPiBpUS1sa3BAaW50ZWwuY29tL2Nv
bmZpZykKPiBjb21waWxlcjogcmlzY3Y2NC1saW51eC1nY2MgKEdDQykgMTIuMS4wCj4gcmVwcm9k
dWNlICh0aGlzIGlzIGEgVz0xIGJ1aWxkKToKPiDCoMKgwqDCoMKgwqDCoCB3Z2V0Cj4gaHR0cHM6
Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ludGVsL2xrcC10ZXN0cy9tYXN0ZXIvc2Jpbi9t
YWtlLmNyb3NzCj4gwqAtTyB+L2Jpbi9tYWtlLmNyb3NzCj4gwqDCoMKgwqDCoMKgwqAgY2htb2Qg
K3ggfi9iaW4vbWFrZS5jcm9zcwo+IMKgwqDCoMKgwqDCoMKgICMKPiBodHRwczovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9oZXJiZXJ0L2NyeXB0b2Rldi0yLjYuZ2l0
L2NvbW1pdC8/aWQ9MWJjN2ZkYmYyNjc3Y2MxODY2YzAyNWU1YTM5MzgxMWVhOGUyNTQ4Ngo+IMKg
wqDCoMKgwqDCoMKgIGdpdCByZW1vdGUgYWRkIGhlcmJlcnQtY3J5cHRvZGV2LTIuNgo+IGh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hlcmJlcnQvY3J5cHRv
ZGV2LTIuNi5naXQKPiDCoMKgwqDCoMKgwqDCoCBnaXQgZmV0Y2ggLS1uby10YWdzIGhlcmJlcnQt
Y3J5cHRvZGV2LTIuNiBtYXN0ZXIKPiDCoMKgwqDCoMKgwqDCoCBnaXQgY2hlY2tvdXQgMWJjN2Zk
YmYyNjc3Y2MxODY2YzAyNWU1YTM5MzgxMWVhOGUyNTQ4Ngo+IMKgwqDCoMKgwqDCoMKgICMgc2F2
ZSB0aGUgY29uZmlnIGZpbGUKPiDCoMKgwqDCoMKgwqDCoCBta2RpciBidWlsZF9kaXIgJiYgY3Ag
Y29uZmlnIGJ1aWxkX2Rpci8uY29uZmlnCj4gwqDCoMKgwqDCoMKgwqAgQ09NUElMRVJfSU5TVEFM
TF9QQVRIPSRIT01FLzBkYXkgQ09NUElMRVI9Z2NjLTEyLjEuMAo+IG1ha2UuY3Jvc3MgVz0xIE89
YnVpbGRfZGlyIEFSQ0g9cmlzY3Ygb2xkZGVmY29uZmlnCj4gwqDCoMKgwqDCoMKgwqAgQ09NUElM
RVJfSU5TVEFMTF9QQVRIPSRIT01FLzBkYXkgQ09NUElMRVI9Z2NjLTEyLjEuMAo+IG1ha2UuY3Jv
c3MgVz0xIE89YnVpbGRfZGlyIEFSQ0g9cmlzY3YgU0hFTEw9L2Jpbi9iYXNoCj4gZHJpdmVycy9j
cnlwdG8vaW50ZWwvaXhwNHh4Lwo+IAo+IElmIHlvdSBmaXggdGhlIGlzc3VlLCBraW5kbHkgYWRk
IGZvbGxvd2luZyB0YWcgd2hlcmUgYXBwbGljYWJsZQo+ID4gUmVwb3J0ZWQtYnk6IGtlcm5lbCB0
ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgo+ID4gTGluazoKPiA+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL29lLWtidWlsZC1hbGwvMjAyMzA0MDYxODQ2Lkc2Y3BQWGlRLWxrcEBpbnRlbC5jb20v
Cj4gCj4gQWxsIGVycm9ycyAobmV3IG9uZXMgcHJlZml4ZWQgYnkgPj4pOgo+IAo+IMKgwqAgSW4g
ZmlsZSBpbmNsdWRlZCBmcm9tIDxjb21tYW5kLWxpbmU+Ogo+IMKgwqAgSW4gZnVuY3Rpb24gJ3Nl
dHVwX2NyeXB0X2Rlc2MnLAo+IMKgwqDCoMKgwqDCoCBpbmxpbmVkIGZyb20gJ2dldF9jcnlwdF9k
ZXNjJyBhdAo+IGRyaXZlcnMvY3J5cHRvL2ludGVsL2l4cDR4eC9peHA0eHhfY3J5cHRvLmM6Mjg1
OjM6Cj4gPiA+IGluY2x1ZGUvbGludXgvY29tcGlsZXJfdHlwZXMuaDozOTc6NDU6IGVycm9yOiBj
YWxsIHRvCj4gPiA+ICdfX2NvbXBpbGV0aW1lX2Fzc2VydF8zODUnIGRlY2xhcmVkIHdpdGggYXR0
cmlidXRlIGVycm9yOgo+ID4gPiBCVUlMRF9CVUdfT04gZmFpbGVkOiBzaXplb2Yoc3RydWN0IGNy
eXB0X2N0bCkgIT0gNjQKPiDCoMKgwqDCoCAzOTcgfMKgwqDCoMKgwqDCoMKgwqAgX2NvbXBpbGV0
aW1lX2Fzc2VydChjb25kaXRpb24sIG1zZywKPiBfX2NvbXBpbGV0aW1lX2Fzc2VydF8sIF9fQ09V
TlRFUl9fKQo+IMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgXgo+IMKgwqAgaW5jbHVkZS9saW51eC9jb21waWxlcl90eXBlcy5oOjM3ODoyNTogbm90ZTog
aW4gZGVmaW5pdGlvbiBvZgo+IG1hY3JvICdfX2NvbXBpbGV0aW1lX2Fzc2VydCcKPiDCoMKgwqDC
oCAzNzggfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBw
cmVmaXggIyMKPiBzdWZmaXgoKTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gwqDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF5+fn5+fgo+IMKgwqAgaW5jbHVkZS9s
aW51eC9jb21waWxlcl90eXBlcy5oOjM5Nzo5OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8K
PiAnX2NvbXBpbGV0aW1lX2Fzc2VydCcKPiDCoMKgwqDCoCAzOTcgfMKgwqDCoMKgwqDCoMKgwqAg
X2NvbXBpbGV0aW1lX2Fzc2VydChjb25kaXRpb24sIG1zZywKPiBfX2NvbXBpbGV0aW1lX2Fzc2Vy
dF8sIF9fQ09VTlRFUl9fKQo+IMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoMKgwqAgXn5+
fn5+fn5+fn5+fn5+fn5+fgo+IMKgwqAgaW5jbHVkZS9saW51eC9idWlsZF9idWcuaDozOTozNzog
bm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvCj4gJ2NvbXBpbGV0aW1lX2Fzc2VydCcKPiDCoMKg
wqDCoMKgIDM5IHwgI2RlZmluZSBCVUlMRF9CVUdfT05fTVNHKGNvbmQsIG1zZykKPiBjb21waWxl
dGltZV9hc3NlcnQoIShjb25kKSwgbXNnKQo+IMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBefn5+fn5+fn5+fn5+fn5+fn4KPiDCoMKgIGluY2x1ZGUvbGludXgvYnVpbGRfYnVnLmg6
NTA6OTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvCj4gJ0JVSUxEX0JVR19PTl9NU0cnCj4g
wqDCoMKgwqDCoCA1MCB8wqDCoMKgwqDCoMKgwqDCoCBCVUlMRF9CVUdfT05fTVNHKGNvbmRpdGlv
biwgIkJVSUxEX0JVR19PTiBmYWlsZWQ6Cj4gIiAjY29uZGl0aW9uKQo+IMKgwqDCoMKgwqDCoMKg
wqAgfMKgwqDCoMKgwqDCoMKgwqAgXn5+fn5+fn5+fn5+fn5+fgo+IMKgwqAgZHJpdmVycy9jcnlw
dG8vaW50ZWwvaXhwNHh4L2l4cDR4eF9jcnlwdG8uYzoyNjY6OTogbm90ZTogaW4KPiBleHBhbnNp
b24gb2YgbWFjcm8gJ0JVSUxEX0JVR19PTicKPiDCoMKgwqDCoCAyNjYgfMKgwqDCoMKgwqDCoMKg
wqAgQlVJTERfQlVHX09OKHNpemVvZihzdHJ1Y3QgY3J5cHRfY3RsKSAhPSA2NCk7Cj4gwqDCoMKg
wqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoCBefn5+fn5+fn5+fn4KPiAKPiAKClRoaXMgaGFw
cGVuZWQgYmVjYXVzZSBJIGFkZGVkIENPTVBJTEVfVEVTVCBhcyBhIGRlcGVuZGVuY3kgYW5kCm9i
dmlvdXNseSBzaG91bGRuJ3QgaGF2ZS4KCldpbGwgc2VuZCBhIHBhdGNoIHRvIHJlbW92ZSBpdC4K
ClRvbSAKCgoK

