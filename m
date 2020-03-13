Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB8DC10DCE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 09:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CCE3206EB
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 09:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgCMJsT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:48:19 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.3]:44110 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgCMJsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 05:48:19 -0400
Received: from [100.113.0.63] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-central-1.aws.symcld.net id 59/94-41233-0E65B6E5; Fri, 13 Mar 2020 09:48:16 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRWlGSWpSXmKPExsVyU+ECq+6DsOw
  4g8PvuCzu3/vJ5MDo8XmTXABjFGtmXlJ+RQJrxvXfj5kKPnNV3Fmyg7WB8QFXFyMXh5DAPkaJ
  m9f/sHYxcgI5ZxklfrZqgNhsAloSM7ZOZQSxRQTsJd6sncoO0sAssIdR4tHWZ8wgCWEBO4mzH
  5ezQRQ5S3T83sMMYetJTNgzjR3EZhFQlTi74BULiM0roCuxY/ttsDijgKzEo5W/wGxmAXGJW0
  /mM4HYEgICEkv2nGeGsEUlXj7+xwphG0hsXbqPBcJWlLg2/wTQcRxAtrXEjQf8ICazgKbE+l3
  6EBMVJaZ0P2SH2CoocXLmE5YJjCKzkCybhdAxC0nHLCQdCxhZVjFaJhVlpmeU5CZm5ugaGhjo
  Ghoa6wJJIzO9xCrdRL3UUt3k1LySokSgrF5iebFecWVuck6KXl5qySZGYMykFDLU7WD8s+a93
  iFGSQ4mJVFeK5/sOCG+pPyUyozE4oz4otKc1OJDjDIcHEoSvPtCgHKCRanpqRVpmTnA+IVJS3
  DwKInwBoYCpXmLCxJzizPTIVKnGC05Jrycu4iZY+fReUDyyNyli5iFWPLy81KlxHnvgjQIgDR
  klObBjYOlmEuMslLCvIwMDAxCPAWpRbmZJajyrxjFORiVhHlngUzhycwrgdv6CuggJqCDeo6l
  gxxUkoiQkmpgEo6X4El04VrpO9WoxfSF3dykZbe8Tn8vt2+dt9vr0wIrW63rXmvrd6t+/eDg9
  oHphGBYsajM60BDW5U525/L7Nh891nrkV3szZs/x6zgSau9ON3Pq+SJU6ng+Qen1xinfFp65s
  4N/1Vnv+WKXr/FWfggk6GzxG/+6ZCPKSkumq/s11ek7pLxMSnc8mTrXfZ9TjdbrnxbYZ24kdN
  42+FHYfcPn359Z2aUprz1pM0Faqd2nPnz/ccDBZa5cvuZeVgMHSpigpa/vK46KZ7hnJnjC931
  HIyZn+YzR/QFOca9iupapHoqVP/oS8386XIV9nu/F7EbNR2wnpBbfGjZ9BXct+pZd3Y+P82+r
  fGbYH3FMiWW4oxEQy3mouJEAGoZ88ysAwAA
X-Env-Sender: david.kim@ncipher.com
X-Msg-Ref: server-30.tower-225.messagelabs.com!1584092895!1395419!2
X-Originating-IP: [217.32.208.5]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2864 invoked from network); 13 Mar 2020 09:48:16 -0000
Received: from unknown (HELO exukdagfar02.INTERNAL.ROOT.TES) (217.32.208.5)
  by server-30.tower-225.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 13 Mar 2020 09:48:16 -0000
Received: from exukdagfar01.INTERNAL.ROOT.TES (10.194.2.70) by
 exukdagfar02.INTERNAL.ROOT.TES (10.194.2.71) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 13 Mar 2020 09:48:15 +0000
Received: from exukdagfar01.INTERNAL.ROOT.TES ([fe80::244b:b200:a68b:9d0c]) by
 exukdagfar01.INTERNAL.ROOT.TES ([fe80::244b:b200:a68b:9d0c%14]) with mapi id
 15.00.1497.000; Fri, 13 Mar 2020 09:48:15 +0000
From:   "Kim, David" <david.kim@ncipher.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: nCipher HSM kernel driver submission feedback request
Thread-Topic: nCipher HSM kernel driver submission feedback request
Thread-Index: AQHV+Rp4QokDxpwiMEuvFqQ47k+kig==
Date:   Fri, 13 Mar 2020 09:48:14 +0000
Message-ID: <1584092894266.92323@ncipher.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.23.136.54]
x-exclaimer-md-config: 7ae4f661-56ee-4cc7-9363-621ce9eeb65f
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgSGVyYmVydCwNCg0KV2UndmUgYmVlbiB3b3JraW5nIG9uIGdldHRpbmcgdGhpcyBkcml2ZXIg
Y29kZSB1cHN0cmVhbWVkIGludG8gZHJpdmVycy9taXNjIHNpbmNlIHRoZSBlbmQgb2YgbGFzdA0K
eWVhciBidXQgdGhpbmdzIHN0YWxsZWQgYSBiaXQgb24gb3VyIGVuZC4gSG93ZXZlciwgd2UgYXJl
IHN0aWxsIGludGVyZXN0ZWQgaW4gZ2V0dGluZyBvdXIgc3VibWlzc2lvbg0KYXBwcm92ZWQgYW5k
IHdvdWxkIHBsZWFzZSBsaWtlIHlvdXIgYXNzaXN0YW5jZSBhbmQgZmVlZGJhY2sgb24gdGhpcy4N
Cg0KVGhlIGRyaXZlciBjb2RlIGZvciB0aGUgaGFyZHdhcmUgaXMgc3RyYWlnaHRmb3J3YXJkIGFu
ZCBkb2VzIG5vdCBjb250YWluIGFueSBjcnlwdG9ncmFwaGljDQpjb21wb25lbnRzIGFzIHRoZSBj
cnlwdG9ncmFwaHkgaXMgaGFuZGxlZCB3aXRoaW4gdGhlIGhhcmR3YXJlJ3Mgc2VjdXJlIGJvdW5k
YXJ5LiBXZSBoYXZlIG5vDQpwbGFucyB0byB1c2UgdGhlIGxpbnV4IGtlcm5lbCBjcnlwdG8gQVBJ
cyBhcyBvdXIgY3VzdG9tZXJzIHJlcXVpcmUgY29tcGxpYW5jZSB0byB0aGUgRklQUyAxNDANCnN0
YW5kYXJkIG9yIHRoZSBlSURBUyByZWd1bGF0aW9ucy4NCg0KSGVyZSBpcyBhIGxpbmsgdG8gdGhl
IHByZXZpb3VzIGVtYWlsIEkgc2VudCwgd2hpY2ggYWxzbyBjb250YWlucyBtb3JlIGJhY2tncm91
bmQgbGlua3MgdG8gb3VyIGluaXRpYWwNCmRpc2N1c3Npb25zIHdpdGggR3JlZyBhbmQgdGhlIGFj
dHVhbCBwYXRjaC4NCg0KaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtY3J5cHRvLXZnZXImbT0x
NTc5MTgyODg0MjM4ODkmdz0yDQoNCkNhbiBJIHBsZWFzZSBoYXZlIHlvdXIgYXBwcm92YWwgb24g
dGhpcyBzdWJtaXNzaW9uPw0KDQpUaGFua3MsDQpEYXZlDQoNCg0KRGF2aWQgS2ltDQpTZW5pb3Ig
U29mdHdhcmUgRW5naW5lZXINClRlbDogKzQ0IDEyMjMgNzAzNDQ5DQoNCm5DaXBoZXIgU2VjdXJp
dHkNCk9uZSBTdGF0aW9uIFNxdWFyZQ0KQ2FtYnJpZGdlIENCMSAyR0ENClVuaXRlZCBLaW5nZG9t
DQoNCg==
