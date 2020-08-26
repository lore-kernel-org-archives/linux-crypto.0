Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3220C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 11:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3A672083B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 11:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgHZLhk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 07:37:40 -0400
Received: from gw.c-home.cz ([89.24.150.100]:40970 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbgHZLeF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 07:34:05 -0400
Received: from dmz.c-home.cz (localhost [127.0.0.1])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 07QBXMIi001058;
        Wed, 26 Aug 2020 13:33:27 +0200 (CEST)
Received: from localhost (martin@localhost)
        by dmz.c-home.cz (8.14.4+Sun/8.14.4/Submit) with ESMTP id 07QBXKnJ001055;
        Wed, 26 Aug 2020 13:33:20 +0200 (CEST)
X-Authentication-Warning: dmz.c-home.cz: martin owned process doing -bs
Date:   Wed, 26 Aug 2020 13:33:20 +0200 (CEST)
From:   Martin Cerveny <martin@c-home.cz>
Reply-To: Martin Cerveny <M.Cerveny@computer.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
cc:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: PROBLEM: SHA1 on Allwinner V3s failed
In-Reply-To: <20200826090738.GA6772@Red>
Message-ID: <alpine.GSO.2.00.2008261256100.29556@dmz.c-home.cz>
References: <alpine.GSO.2.00.2008260919550.23953@dmz.c-home.cz> <20200826090738.GA6772@Red>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-824023566-1598441544=:771"
Content-ID: <alpine.GSO.2.00.2008261332330.771@dmz.c-home.cz>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-824023566-1598441544=:771
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <alpine.GSO.2.00.2008261332331.771@dmz.c-home.cz>

Hello.

On Wed, 26 Aug 2020, Corentin Labbe wrote:
> On Wed, Aug 26, 2020 at 09:52:30AM +0200, Martin Cerveny wrote:
>> Hello.
>>
>> [1.] One line summary of the problem:
>>
>> SHA1 on Allwinner V3s failed
>>
> Since only SHA1 is failling, could you try to use the "allwinner,sun8i-a33-crypto", just in case V3s has the same SHA1 HW quirck than A33.

Yes. This do the trick. All startup verification passes now.
Performance (SHA1 with sha1-sun4i-ss) "tcrypt mode=303 sec=1" test output attached.
So, all seems to be working now. Released new patch with possibility to merge.

https://github.com/mcerveny/linux/commit/e3c76436de3d8cd2b2ddaeadef879a4a4d723bf4

Regards, Martin
---559023410-824023566-1598441544=:771
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=v3s-crypto-sha1.txt
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.GSO.2.00.2008261332240.771@dmz.c-home.cz>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=v3s-crypto-sha1.txt

cm9vdEBMaWNoZWVQaTp+IyBtb2Rwcm9iZSB0Y3J5cHQgbW9kZT0zMDMgc2Vj
PTENClsgIDgwNS4yNjg1NTldIA0KWyAgODA1LjI2ODU1OV0gdGVzdGluZyBz
cGVlZCBvZiBhc3luYyBzaGExIChzaGExLXN1bjRpLXNzKQ0KWyAgODA1LjI3
NTMyOF0gdGNyeXB0OiB0ZXN0ICAwICggICAxNiBieXRlIGJsb2NrcywgICAx
NiBieXRlcyBwZXIgdXBkYXRlLCAgIDEgdXBkYXRlcyk6IA0KWyAgODA2LjI2
NzQwNl0gMjc2NzczIG9wZXJzL3NlYywgICA0NDI4MzY4IGJ5dGVzL3NlYw0K
WyAgODA2LjI4NTI3OF0gdGNyeXB0OiB0ZXN0ICAxICggICA2NCBieXRlIGJs
b2NrcywgICAxNiBieXRlcyBwZXIgdXBkYXRlLCAgIDQgdXBkYXRlcyk6ICA5
OTc5NSBvcGVycy9zZWMsICAgNjM4Njg4MCBieXRlcy9zZWMNClsgIDgwNy4y
ODk2NTddIHRjcnlwdDogdGVzdCAgMiAoICAgNjQgYnl0ZSBibG9ja3MsICAg
NjQgYnl0ZXMgcGVyIHVwZGF0ZSwgICAxIHVwZGF0ZXMpOiANClsgIDgwOC4y
ODc0MDVdIDIzMTcxOSBvcGVycy9zZWMsICAxNDgzMDAxNiBieXRlcy9zZWMN
ClsgIDgwOC4zMDEyNTZdIHRjcnlwdDogdGVzdCAgMyAoICAyNTYgYnl0ZSBi
bG9ja3MsICAgMTYgYnl0ZXMgcGVyIHVwZGF0ZSwgIDE2IHVwZGF0ZXMpOiAg
MzQ3Mzkgb3BlcnMvc2VjLCAgIDg4OTMxODQgYnl0ZXMvc2VjDQpbICA4MDku
MzA5NDMyXSB0Y3J5cHQ6IHRlc3QgIDQgKCAgMjU2IGJ5dGUgYmxvY2tzLCAg
IDY0IGJ5dGVzIHBlciB1cGRhdGUsICAgNCB1cGRhdGVzKTogIDQ4MDIzIG9w
ZXJzL3NlYywgIDEyMjkzODg4IGJ5dGVzL3NlYw0KWyAgODEwLjMyMTI3OF0g
dGNyeXB0OiB0ZXN0ICA1ICggIDI1NiBieXRlIGJsb2NrcywgIDI1NiBieXRl
cyBwZXIgdXBkYXRlLCAgIDEgdXBkYXRlcyk6IA0KWyAgODExLjMxNzQwNl0g
MTYwOTA4IG9wZXJzL3NlYywgIDQxMTkyNDQ4IGJ5dGVzL3NlYw0KWyAgODEx
LjMzMTMwNV0gdGNyeXB0OiB0ZXN0ICA2ICggMTAyNCBieXRlIGJsb2Nrcywg
ICAxNiBieXRlcyBwZXIgdXBkYXRlLCAgNjQgdXBkYXRlcyk6ICAgOTUzMiBv
cGVycy9zZWMsICAgOTc2MDc2OCBieXRlcy9zZWMNClsgIDgxMi4zMzkyODRd
IHRjcnlwdDogdGVzdCAgNyAoIDEwMjQgYnl0ZSBibG9ja3MsICAyNTYgYnl0
ZXMgcGVyIHVwZGF0ZSwgICA0IHVwZGF0ZXMpOiAgMzQwNjkgb3BlcnMvc2Vj
LCAgMzQ4ODY2NTYgYnl0ZXMvc2VjDQpbICA4MTMuMzQ5NTIxXSB0Y3J5cHQ6
IHRlc3QgIDggKCAxMDI0IGJ5dGUgYmxvY2tzLCAxMDI0IGJ5dGVzIHBlciB1
cGRhdGUsICAgMSB1cGRhdGVzKTogDQpbICA4MTQuMzQ3NDIxXSAgNzA5NDEg
b3BlcnMvc2VjLCAgNzI2NDM1ODQgYnl0ZXMvc2VjDQpbICA4MTQuMzYxODU1
XSB0Y3J5cHQ6IHRlc3QgIDkgKCAyMDQ4IGJ5dGUgYmxvY2tzLCAgIDE2IGJ5
dGVzIHBlciB1cGRhdGUsIDEyOCB1cGRhdGVzKTogICA0ODQyIG9wZXJzL3Nl
YywgICA5OTE2NDE2IGJ5dGVzL3NlYw0KWyAgODE1LjM2OTc2OF0gdGNyeXB0
OiB0ZXN0IDEwICggMjA0OCBieXRlIGJsb2NrcywgIDI1NiBieXRlcyBwZXIg
dXBkYXRlLCAgIDggdXBkYXRlcyk6ICAxODQwMSBvcGVycy9zZWMsICAzNzY4
NTI0OCBieXRlcy9zZWMNClsgIDgxNi4zNzkyNjZdIHRjcnlwdDogdGVzdCAx
MSAoIDIwNDggYnl0ZSBibG9ja3MsIDEwMjQgYnl0ZXMgcGVyIHVwZGF0ZSwg
ICAyIHVwZGF0ZXMpOiAgMzEzNzkgb3BlcnMvc2VjLCAgNjQyNjQxOTIgYnl0
ZXMvc2VjDQpbICA4MTcuMzg5NDM4XSB0Y3J5cHQ6IHRlc3QgMTIgKCAyMDQ4
IGJ5dGUgYmxvY2tzLCAyMDQ4IGJ5dGVzIHBlciB1cGRhdGUsICAgMSB1cGRh
dGVzKTogDQpbICA4MTguMzg3NDE1XSAgNDA2Mjggb3BlcnMvc2VjLCAgODMy
MDYxNDQgYnl0ZXMvc2VjDQpbICA4MTguNDAxMDQzXSB0Y3J5cHQ6IHRlc3Qg
MTMgKCA0MDk2IGJ5dGUgYmxvY2tzLCAgIDE2IGJ5dGVzIHBlciB1cGRhdGUs
IDI1NiB1cGRhdGVzKTogICAyNDQzIG9wZXJzL3NlYywgIDEwMDA2NTI4IGJ5
dGVzL3NlYw0KWyAgODE5LjQxMDE0MF0gdGNyeXB0OiB0ZXN0IDE0ICggNDA5
NiBieXRlIGJsb2NrcywgIDI1NiBieXRlcyBwZXIgdXBkYXRlLCAgMTYgdXBk
YXRlcyk6ICAgOTQ4MCBvcGVycy9zZWMsICAzODgzMDA4MCBieXRlcy9zZWMN
ClsgIDgyMC40MTkzOTNdIHRjcnlwdDogdGVzdCAxNSAoIDQwOTYgYnl0ZSBi
bG9ja3MsIDEwMjQgYnl0ZXMgcGVyIHVwZGF0ZSwgICA0IHVwZGF0ZXMpOiAg
MTY1Mzggb3BlcnMvc2VjLCAgNjc3Mzk2NDggYnl0ZXMvc2VjDQpbICA4MjEu
NDI5NDYzXSB0Y3J5cHQ6IHRlc3QgMTYgKCA0MDk2IGJ5dGUgYmxvY2tzLCA0
MDk2IGJ5dGVzIHBlciB1cGRhdGUsICAgMSB1cGRhdGVzKTogDQpbICA4MjIu
NDI3NDQ3XSAgMjE5NDMgb3BlcnMvc2VjLCAgODk4Nzg1MjggYnl0ZXMvc2Vj
DQpbICA4MjIuNDQxMTgyXSB0Y3J5cHQ6IHRlc3QgMTcgKCA4MTkyIGJ5dGUg
YmxvY2tzLCAgIDE2IGJ5dGVzIHBlciB1cGRhdGUsIDUxMiB1cGRhdGVzKTog
ICAxMjI3IG9wZXJzL3NlYywgIDEwMDUxNTg0IGJ5dGVzL3NlYw0KWyAgODIz
LjQ0OTk4N10gdGNyeXB0OiB0ZXN0IDE4ICggODE5MiBieXRlIGJsb2Nrcywg
IDI1NiBieXRlcyBwZXIgdXBkYXRlLCAgMzIgdXBkYXRlcyk6ICAgNDgxNCBv
cGVycy9zZWMsICAzOTQzNjI4OCBieXRlcy9zZWMNClsgIDgyNC40NTk0MzVd
IHRjcnlwdDogdGVzdCAxOSAoIDgxOTIgYnl0ZSBibG9ja3MsIDEwMjQgYnl0
ZXMgcGVyIHVwZGF0ZSwgICA4IHVwZGF0ZXMpOiAgIDg1MDEgb3BlcnMvc2Vj
LCAgNjk2NDAxOTIgYnl0ZXMvc2VjDQpbICA4MjUuNDY5NDY2XSB0Y3J5cHQ6
IHRlc3QgMjAgKCA4MTkyIGJ5dGUgYmxvY2tzLCA0MDk2IGJ5dGVzIHBlciB1
cGRhdGUsICAgMiB1cGRhdGVzKTogIDEwNTQ3IG9wZXJzL3NlYywgIDg2NDAx
MDI0IGJ5dGVzL3NlYw0KWyAgODI2LjQ3OTI4NV0gdGNyeXB0OiB0ZXN0IDIx
ICggODE5MiBieXRlIGJsb2NrcywgODE5MiBieXRlcyBwZXIgdXBkYXRlLCAg
IDEgdXBkYXRlcyk6IA0KWyAgODI3LjQ3NzQ3NF0gIDExNDI0IG9wZXJzL3Nl
YywgIDkzNTg1NDA4IGJ5dGVzL3NlYw0KbW9kcHJvYmU6IEVSUk9SOiBjb3Vs
ZCBub3QgaW5zZXJ0ICd0Y3J5cHQnOiBSZXNvdXJjZSB0ZW1wb3JhcmlseSB1
bmF2YWlsYWJsZQ0KDQo=

---559023410-824023566-1598441544=:771--
