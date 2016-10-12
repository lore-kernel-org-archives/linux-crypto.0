From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] padata: add helper function for queue length
Date: Wed, 12 Oct 2016 14:23:50 +0200
Message-ID: <CAHmME9qknfkgimz=ig+Qe1frOPzdW2E0Oae7207C6zdoT2Mm3Q@mail.gmail.com>
References: <20161002014638.8049-1-Jason@zx2c4.com> <20161007031501.GB23615@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161007031501.GB23615@gauss.secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Steffen,

On Fri, Oct 7, 2016 at 5:15 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> Why you want to have this?

I'm working on some bufferbloat/queue code that could benefit from
knowing how many items are currently in flight. The goal is to always
keep padata busy, but never with more jobs than absolutely necessary.
The model is CoDel.

Regards,
Jason
