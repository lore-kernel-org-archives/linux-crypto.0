From: "Loc Ho" <lho@amcc.com>
Subject: RE: Test AES-CCM mode via IPSec (NETKEY)
Date: Fri, 4 Apr 2008 16:08:16 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6044D59F9@SDCEXCHANGE01.ad.amcc.com>
References: <E1JSQiw-0002dT-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043753E4@SDCEXCHANGE01.ad.amcc.com> <1207348646.4158.3.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "Joy Latten" <latten@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01-ext1.amcc.com ([198.137.200.72]:56213 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYDDXxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Apr 2008 19:53:30 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1207348646.4158.3.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Try these scripts with proper IP address. In addition, you must patch
iproute2 manually using the patch from Herbert's email:

[lho@svdclab161 sec]$ cat ip-start-transport-ccm
#!/bin/sh

NODE=$1

echo "Starting IPSec transport mode using CCM..."

./ip xfrm policy flush
./ip xfrm state flush
#
# SA
./ip xfrm state add src 10.66.21.164 dst 10.66.21.166 proto esp spi
0x201 mode transport aead "rfc4309(ccm(aes))"
0x0102037aeaca3f87d060a12f4a4487d5a5c335 96
./ip xfrm state add src 10.66.21.166 dst 10.66.21.164 proto esp spi
0x301 mode transport aead "rfc4309(ccm(aes))"
0x010203f6ddb555acfd9d77b03ea3843f265325 96
#
# Policy
if [ "${NODE}" = "A" ]; then
        ./ip xfrm policy add dir out src 10.66.21.164 dst 10.66.21.166
tmpl proto esp mode transport
        ./ip xfrm policy add dir in src 10.66.21.166 dst 10.66.21.164
tmpl proto esp mode transport
fi
if [ "${NODE}" = "B" ]; then
        ./ip xfrm policy add dir in src 10.66.21.164 dst 10.66.21.166
tmpl proto esp mode transport
        ./ip xfrm policy add dir out src 10.66.21.166 dst 10.66.21.164
tmpl proto esp mode transport
fi
 
[lho@svdclab161 sec]$ cat ip-start-transport-gcm
#!/bin/sh

NODE=$1

echo "Starting IPSec transport mode using GCM..."

./ip xfrm policy flush
./ip xfrm state flush
#
# SA
./ip xfrm state add src 10.66.21.164 dst 10.66.21.166 proto esp spi
0x201 mode transport aead "rfc4106(gcm(aes))"
0x010203047aeaca3f87d060a12f4a4487d5a5c335 96
./ip xfrm state add src 10.66.21.166 dst 10.66.21.164 proto esp spi
0x301 mode transport aead "rfc4106(gcm(aes))"
0x01020304f6ddb555acfd9d77b03ea3843f265325 96
#
# Policy
if [ "${NODE}" = "A" ]; then
        ./ip xfrm policy add dir out src 10.66.21.164 dst 10.66.21.166
tmpl proto esp mode transport
        ./ip xfrm policy add dir in src 10.66.21.166 dst 10.66.21.164
tmpl proto esp mode transport
fi
if [ "${NODE}" = "B" ]; then
        ./ip xfrm policy add dir in src 10.66.21.164 dst 10.66.21.166
tmpl proto esp mode transport
        ./ip xfrm policy add dir out src 10.66.21.166 dst 10.66.21.164
tmpl proto esp mode transport
fi

-Loc
