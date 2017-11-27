From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH] X.509: fix comparisons of ->pkey_algo
Date: Mon, 27 Nov 2017 19:22:59 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1711271922480.2808@localhost>
References: <20171127071724.25874-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171127071724.25874-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 26 Nov 2017, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> ->pkey_algo used to be an enum, but was changed to a string by commit
> 4e8ae72a75aa ("X.509: Make algo identifiers text instead of enum").  But
> two comparisons were not updated.  Fix them to use strcmp().
> 
> This bug broke signature verification in certain configurations,
> depending on whether the string constants were deduplicated or not.
> 
> Fixes: 4e8ae72a75aa ("X.509: Make algo identifiers text instead of enum")
> Cc: <stable@vger.kernel.org> # v4.6+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/asymmetric_keys/pkcs7_verify.c    | 2 +-
>  crypto/asymmetric_keys/x509_public_key.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>
