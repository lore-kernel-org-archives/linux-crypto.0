From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/crypto: fix %progbits -> @progbits
Date: Thu, 19 Jan 2017 15:32:55 -0600
Message-ID: <20170119213255.ur3v3ihh3lcuavzw@treble>
References: <20170119212805.18049-1-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170119212805.18049-1-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 19, 2017 at 10:28:05PM +0100, Denys Vlasenko wrote:
> %progbits form is used on ARM (where @ is a comment char).
> 
> x86 consistently uses @progbits everywhere else.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
