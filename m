From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH] hwrng: core - don't pass stack allocated buffer to
 rng->read()
Date: Fri, 21 Oct 2016 22:43:44 +0200
Message-ID: <55c26d3c-0216-ad74-accc-7ee9ff7007a6@redhat.com>
References: <20161021203204.12556-1-lersek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org#Forv3.15+, Amit Shah <amit.shah@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>,
        Matt Mackall <mpm@selenic.com>,
        "Richard W . M . Jones" <rjones@redhat.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161021203204.12556-1-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/21/16 22:32, Laszlo Ersek wrote:
> [...]

Self-NAK, I'll resend in a minute. I added a tag like this:

Cc: <stable@vger.kernel.org> # For v3.15+

and git turned it into a garbage email address. I'll drop the "# For
v3.15+" part in the repost.

(I'll also add explicit quotes around Rich's name -- I had a suspicion
that the dots wouldn't be correct without quoting. git-send-email
armored them itself, but it also inserted gratuitous whitespace in front
of the dots.)

Sorry about the inconvenience.

Thanks
Laszlo
