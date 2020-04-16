Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC52C2BA2B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1D120787
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408362AbgDPGi0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:38:26 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:51864 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408304AbgDPGiU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:38:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0TvgSr.7_1587019046;
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TvgSr.7_1587019046)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Apr 2020 14:37:27 +0800
Subject: Re: [PATCH v2 0/7] crpyto: introduce OSCCA certificate and SM2
 asymmetric algorithm
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, ebiggers@kernel.org, ebiggers@google.com,
        pvanleeuwen@rambus.com, zohar@linux.ibm.com, gilad@benyossef.com,
        jarkko.sakkinen@linux.intel.com, dmitry.kasatkin@intel.com,
        nicstange@gmail.com, tadeusz.struk@intel.com, jmorris@namei.org,
        serge@hallyn.com, zhang.jia@linux.alibaba.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200402123504.84628-1-tianjia.zhang@linux.alibaba.com>
 <20200416060136.GA19149@gondor.apana.org.au>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <f0122a77-714d-7fc3-4272-2bf9bd36da5c@linux.alibaba.com>
Date:   Thu, 16 Apr 2020 14:37:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416060136.GA19149@gondor.apana.org.au>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/4/16 14:01, Herbert Xu wrote:
> On Thu, Apr 02, 2020 at 08:34:57PM +0800, Tianjia Zhang wrote:
>> Hello all,
>>
>> This new module implement the OSCCA certificate and SM2 public key
>> algorithm. It was published by State Encryption Management Bureau, China.
>> List of specifications for OSCCA certificate and SM2 elliptic curve
>> public key cryptography:
>>
>> * GM/T 0003.1-2012
>> * GM/T 0003.2-2012
>> * GM/T 0003.3-2012
>> * GM/T 0003.4-2012
>> * GM/T 0003.5-2012
>> * GM/T 0015-2012
>> * GM/T 0009-2012
>>
>> IETF: https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
>> oscca: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
>> scctc: http://www.gmbz.org.cn/main/bzlb.html
>>
>> These patchs add the OID object identifier defined by OSCCA. The
>> x509 certificate supports sm2-with-sm3 type certificate parsing
>> and verification.
> 
> I don't have any objections to the crypto API bits, but obviously
> this is contingent on the x509 bits getting accepted since that's
> the only in-kernel user.  So can I see some acks on that please?
> 
> Thanks,
> 

Thanks for Herbert's reply. At present, the latest mainline openssl can 
generate SM2-with-SM3 certificates. I also provide commands for 
generating certificates and a test certificate in PEM format.

``` bash
#!/bin/bash

if [ ! -f openssl.cnf ]; then
	cat > openssl.cnf << EOF
[ req ]
default_bits = 2048
distinguished_name = req_distinguished_name
prompt = no
string_mask = utf8only
x509_extensions = v3_req

[ req_distinguished_name ]
O = Test
OU = Test
CN = Test key
emailAddress = test@foo.com

[ v3_req ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
EOF
fi

openssl ecparam -genkey -name SM2 -text -out private.pem

openssl req -new \
	-key private.pem \
	-out csr.pem \
	-sm3 -sigopt "distid:1234567812345678" \
     -subj 
"/C=CN/ST=GS/L=Gt/O=baba/OU=OS/CN=hello/emailAddress=hello@world.com"

openssl ecparam -genkey -name SM2 -text -out ca.key

openssl req -new \
     -x509 -days 3650 \
     -sm3 -sigopt "distid:1234567812345678" \
     -key ca.key \
     -out ca.crt \
     -subj "/C=CN/ST=GS/L=Gt/O=baba/OU=OS/CN=ca/emailAddress=ca@world.com"

openssl x509 -req -days 3650 \
     -sm3 \
     -sigopt "distid:1234567812345678" \
	-vfyopt "distid:1234567812345678" \
     -CA ca.crt -CAkey ca.key -CAcreateserial \
     -extfile openssl.cnf -extensions v3_req \
     -in csr.pem \
     -out cert.pem

openssl x509 -in ca.crt -outform DER -out ca.der
openssl x509 -in cert.pem -outform DER -out cert.der
```

The following content is the CA certificate and the signed SM2-with-SM3 
certificate generated by the above command, both in PEM format.

-----BEGIN CERTIFICATE-----
MIICLjCCAdWgAwIBAgIUEoozP6LzMYWh4gCpcWlzsUyfgsIwCgYIKoEcz1UBg3Uw
bTELMAkGA1UEBhMCQ04xCzAJBgNVBAgMAkdTMQswCQYDVQQHDAJHdDENMAsGA1UE
CgwEYmFiYTELMAkGA1UECwwCT1MxCzAJBgNVBAMMAmNhMRswGQYJKoZIhvcNAQkB
FgxjYUB3b3JsZC5jb20wHhcNMjAwNDE1MTE1NDA3WhcNMzAwNDEzMTE1NDA3WjBt
MQswCQYDVQQGEwJDTjELMAkGA1UECAwCR1MxCzAJBgNVBAcMAkd0MQ0wCwYDVQQK
DARiYWJhMQswCQYDVQQLDAJPUzELMAkGA1UEAwwCY2ExGzAZBgkqhkiG9w0BCQEW
DGNhQHdvcmxkLmNvbTBZMBMGByqGSM49AgEGCCqBHM9VAYItA0IABMTGRiHezKm5
MiKHlyfa5Bv5jLxge/WRRG0nLNsZx1yf0XQTQBR/tFFjPGePEr7+Fa1CPgYpXExx
i44coYMmQT6jUzBRMB0GA1UdDgQWBBSjd9GWIe98Ll9J0dquxgCktp9DrTAfBgNV
HSMEGDAWgBSjd9GWIe98Ll9J0dquxgCktp9DrTAPBgNVHRMBAf8EBTADAQH/MAoG
CCqBHM9VAYN1A0cAMEQCIAvLWIfGFq85u/vVMLc5H1D/DnrNS0VhSkQA4daRO4tc
AiABbeWENcQZDZLWTuqG9P2KDPOoNqV/QV/+0XjMAVblhg==
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIICPzCCAeWgAwIBAgIUIaawP5HQDi5kTruyhLudFfeQ7uwwCgYIKoEcz1UBg3Uw
bTELMAkGA1UEBhMCQ04xCzAJBgNVBAgMAkdTMQswCQYDVQQHDAJHdDENMAsGA1UE
CgwEYmFiYTELMAkGA1UECwwCT1MxCzAJBgNVBAMMAmNhMRswGQYJKoZIhvcNAQkB
FgxjYUB3b3JsZC5jb20wHhcNMjAwNDE1MTE1NDA3WhcNMzAwNDEzMTE1NDA3WjBz
MQswCQYDVQQGEwJDTjELMAkGA1UECAwCR1MxCzAJBgNVBAcMAkd0MQ0wCwYDVQQK
DARiYWJhMQswCQYDVQQLDAJPUzEOMAwGA1UEAwwFaGVsbG8xHjAcBgkqhkiG9w0B
CQEWD2hlbGxvQHdvcmxkLmNvbTBZMBMGByqGSM49AgEGCCqBHM9VAYItA0IABI6g
M2mRfj3srY7wRV4TPmhbjKtcxshQ35EA4CRzTTHyLsDVa+7amJPs2Daquc9jgu+n
GgPtFrp0uIv55XA5pHCjXTBbMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQDAgeAMB0G
A1UdDgQWBBQ76UB0skz7y4ic5V/PIWFLZ5XoDDAfBgNVHSMEGDAWgBSjd9GWIe98
Ll9J0dquxgCktp9DrTAKBggqgRzPVQGDdQNIADBFAiEA25WAmaN7g7M26lwMad4H
AeO8YNSBOcHKc8AfCdYSS88CIBJji4xRm+wXCR9qkXj4g8HVhaYpvwlMukk9EYxw
09gJ
-----END CERTIFICATE-----


The following is the certificate information of SM2-with-SM3, the 
following command output:
`openssl x509 -in cert.pem -noout -text`

Certificate:
     Data:
         Version: 3 (0x2)
         Serial Number:
             21:a6:b0:3f:91:d0:0e:2e:64:4e:bb:b2:84:bb:9d:15:f7:90:ee:ec
         Signature Algorithm: SM2-with-SM3
         Issuer: C = CN, ST = GS, L = Gt, O = baba, OU = OS, CN = ca, 
emailAddress = ca@world.com
         Validity
             Not Before: Apr 15 11:54:07 2020 GMT
             Not After : Apr 13 11:54:07 2030 GMT
         Subject: C = CN, ST = GS, L = Gt, O = baba, OU = OS, CN = 
hello, emailAddress = hello@world.com
         Subject Public Key Info:
             Public Key Algorithm: id-ecPublicKey
                 Public-Key: (256 bit)
                 pub:
                     04:8e:a0:33:69:91:7e:3d:ec:ad:8e:f0:45:5e:13:
                     3e:68:5b:8c:ab:5c:c6:c8:50:df:91:00:e0:24:73:
                     4d:31:f2:2e:c0:d5:6b:ee:da:98:93:ec:d8:36:aa:
                     b9:cf:63:82:ef:a7:1a:03:ed:16:ba:74:b8:8b:f9:
                     e5:70:39:a4:70
                 ASN1 OID: SM2
         X509v3 extensions:
             X509v3 Basic Constraints: critical
                 CA:FALSE
             X509v3 Key Usage:
                 Digital Signature
             X509v3 Subject Key Identifier:
                 3B:E9:40:74:B2:4C:FB:CB:88:9C:E5:5F:CF:21:61:4B:67:95:E8:0C
             X509v3 Authority Key Identifier:
                 A3:77:D1:96:21:EF:7C:2E:5F:49:D1:DA:AE:C6:00:A4:B6:9F:43:AD
     Signature Algorithm: SM2-with-SM3
     Signature Value:
         30:45:02:21:00:db:95:80:99:a3:7b:83:b3:36:ea:5c:0c:69:
         de:07:01:e3:bc:60:d4:81:39:c1:ca:73:c0:1f:09:d6:12:4b:
         cf:02:20:12:63:8b:8c:51:9b:ec:17:09:1f:6a:91:78:f8:83:
         c1:d5:85:a6:29:bf:09:4c:ba:49:3d:11:8c:70:d3:d8:09



If additional information is needed, I can provide it.

Thanks and best,
Tianjia
