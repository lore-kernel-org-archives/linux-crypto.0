From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] chacha20-ssse3/avx2: satisfy stack validation 2.0
Date: Mon, 9 Oct 2017 00:24:39 +0200
Message-ID: <CAHmME9oV=2ZONZ3xZPnj5Htg76WMNNnRse8VrHR6jQwbyGuHSw@mail.gmail.com>
References: <20171008205053.13201-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171008205053.13201-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

s/objdump/objtool/g obviously.
