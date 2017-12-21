From: Cheah Kok Cheong <thrust73@gmail.com>
Subject: Re: [PATCH 1/2] padata: Remove FSF address
Date: Thu, 21 Dec 2017 19:05:57 +0800
Message-ID: <20171221110557.GA7329@linux-Precision-WorkStation-T5500>
References: <1513800921-12452-1-git-send-email-thrust73@gmail.com>
 <CAOFm3uGvuyHcKQ9vvZ1=U3D3Qp8N4npU-JSkWmyr-=9aYv=vzw@mail.gmail.com>
 <20171220211728.GA2383@linux-Precision-WorkStation-T5500>
 <CAOFm3uEf+ZcoQqvAeiKWY5S36RtFeVS+HBpYh2o2TXk2mqvgow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
To: Philippe Ombredanne <pombredanne@nexb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOFm3uEf+ZcoQqvAeiKWY5S36RtFeVS+HBpYh2o2TXk2mqvgow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 21, 2017 at 08:34:37AM +0100, Philippe Ombredanne wrote:
> Dear CheahKC,
> 
> On Wed, Dec 20, 2017 at 10:17 PM, Cheah Kok Cheong <thrust73@gmail.com> wrote:
> > On Wed, Dec 20, 2017 at 09:20:48PM +0100, Philippe Ombredanne wrote:
> >> On Wed, Dec 20, 2017 at 9:15 PM, Cheah Kok Cheong <thrust73@gmail.com> wrote:
> >> > Remove FSF address otherwise checkpatch will flag my next patch.
> >> >
> >> > Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
> >> > ---
> >> >  kernel/padata.c | 4 ----
> >> >  1 file changed, 4 deletions(-)
> >> >
> >> > diff --git a/kernel/padata.c b/kernel/padata.c
> >> > index 57c0074..9d91909 100644
> >> > --- a/kernel/padata.c
> >> > +++ b/kernel/padata.c
> >> > @@ -14,10 +14,6 @@
> >> >   * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> >> >   * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> >> >   * more details.
> >> > - *
> >> > - * You should have received a copy of the GNU General Public License along with
> >> > - * this program; if not, write to the Free Software Foundation, Inc.,
> >> > - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> >> >   */
> >> >
> >> >  #include <linux/export.h>
> >> > --
> >> > 2.7.4
> >> >
> >>
> >>
> >> Why not use instead the simpler SPDX ids?
> >> --
> >> Cordially
> >> Philippe Ombredanne
> >
> > Hi Philippe,
> >   Adding the SPDX id can be the subject of a separate patch.
> > Believe you are part of the team doing an audit in this matter.
> > I shall leave adding the SPDX id to you guys the professionals.
> > Looks like you guys are using script to do this en masse.
> >
> > But if you insist and our maintainer is agreeable, I can send
> > another patch to add the SPDX id.
> 
> If you could work it out directly that would be best. There are a lot
> of files in the kernel and each one needs a careful review even with
> best license detection script (which . So tagging files on the go when
> they are updated is the best way to help!
> 
> Thank you.
> 
> -- 
> Cordially
> Philippe Ombredanne
>
Ok I'll send a separate patch to add the SPDX id. Glad to help.

Thank you.

Brgds,
CheahKC
