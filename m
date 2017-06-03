From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Staging: ccree: ssi_aead.h: Fixed a pointer declaration
 error.
Date: Sat, 3 Jun 2017 17:37:41 +0900
Message-ID: <20170603083741.GB29531@kroah.com>
References: <1496443518-18497-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: srishti sharma <srishtishar@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1496443518-18497-1-git-send-email-srishtishar@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 03, 2017 at 04:15:17AM +0530, srishti sharma wrote:
> Fixed a pointer declaration error , the dereferencing operator was misplaced.

Odd use of a ,

Also, I don't understand what was "misplaced" here?  There does not seem
to be a "error" fixed here...
