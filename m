From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next] crypto: algif - explicitly mark end of data
Date: Wed, 01 Apr 2015 23:00:00 -0400 (EDT)
Message-ID: <20150401.230000.1791985984239259518.davem@davemloft.net>
References: <20150401205305.22123.71178.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: tadeusz.struk@intel.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20150401205305.22123.71178.stgit@tstruk-mobl1>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Wed, 01 Apr 2015 13:53:06 -0700

> After the TX sgl is expanded we need to explicitly mark end of data
> at the last buffer that contains data.
> 
> Changes in v2
>  - use type 'bool' and true/false for 'mark'.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
