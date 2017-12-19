From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] crypto: x86/twofish-3way - Fix %rbp usage
Date: Tue, 19 Dec 2017 14:37:07 +0000
Message-ID: <a4fecc01e8a14142a9add860aa2ec67a@AcuMS.aculab.com>
References: <001a113f2cd26f3532055f0f4a79@google.com>
 <20171219004026.170565-1-ebiggers3@gmail.com>
 <20171219075443.tdpt2l72eelhpi7j@gmail.com>
 <44b42058-c465-4d1e-7710-198754efabe4@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        Eric Biggers <ebiggers@google.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>
To: 'Juergen Gross' <jgross@suse.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric Biggers" <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <44b42058-c465-4d1e-7710-198754efabe4@suse.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

RnJvbTogSnVlcmdlbiBHcm9zcw0KPiBTZW50OiAxOSBEZWNlbWJlciAyMDE3IDA4OjA1DQouLg0K
PiANCj4gRXhjaGFuZ2luZyAyIHJlZ2lzdGVycyBjYW4gYmUgZG9uZSB3aXRob3V0IG1lbW9yeSBh
Y2Nlc3MgdmlhOg0KPiANCj4geG9yIHJlZzEsIHJlZzINCj4geG9yIHJlZzIsIHJlZzENCj4geG9y
IHJlZzEsIHJlZzINCg0KVGhhdCdsbCBnZW5lcmF0ZSBob3JyaWQgZGF0YSBkZXBlbmRlbmNpZXMu
DQpJU1RSIHRoYXQgdGhlcmUgYXJlIHNvbWUgb3B0aW1pc2F0aW9ucyBmb3IgdGhlIHN0YWNrLA0K
c28gZXZlbiAncHVzaCByZWcxJywgJ21vdiByZWcyLHJlZzEnLCAncG9wIHJlZzInIG1pZ2h0DQpi
ZSBmYXN0ZXIgdGhhbiB0aGUgYWJvdmUuDQoNCglEYXZpZA0KDQo=
